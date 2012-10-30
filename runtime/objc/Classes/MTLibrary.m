//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary+Internal.h"

#import "MTDataElement.h"
#import "MTDefs.h"
#import "MTUtils.h"
#import "MTTypeInfo.h"
#import "MTObjectMarshaller.h"
#import "MTPrimitiveMarshaller.h"
#import "MTMutableTome.h"
#import "MTMutablePage.h"
#import "MTMutablePageRef.h"
#import "MTProp.h"
#import "MTLoadTask.h"
#import "MTLoadException.h"

static NSString* const TEMPLATE_ATTR = @"template";
static NSString* const TYPE_ATTR = @"type";

/// TemplatedPage

@interface MTTemplatedPage : NSObject {
@protected
    MTMutablePage* _page;
    MTDataReader* _data;
}
@property (nonatomic,readonly) MTMutablePage* page;
@property (nonatomic,readonly) id<MTDataElement> data;
@property (nonatomic,readonly) NSString* templateName;

- (id)initWithPage:(MTMutablePage*)page data:(id<MTDataElement>)data;
@end

@implementation MTLibrary

@synthesize primitiveMarshaller = _primitiveMarshaller;

- (id)init {
    if ((self = [super init])) {
        _pageClasses = [[NSMutableDictionary alloc] init];
        _items = [[NSMutableDictionary alloc] init];
        _objectMarshallers = [[NSMutableDictionary alloc] init];

        [self registerObjectMarshaller:[[MTStringMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTListMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTPageMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTPageRefMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTTomeMarshaller alloc] init]];

        _primitiveMarshaller = [[MTDefaultPrimitiveMarshaller alloc] init];
    }
    return self;
}

- (void)loadData:(NSArray*)dataElements {
    NSAssert(_loadTask == nil, @"Load already in progress!");
    _loadTask = [[MTLoadTask alloc] init];

    @try {
        for (id<MTDataElement> doc in dataElements) {
            for (id<MTDataElement> itemData in [MTDataReader withData:doc].children) {
                [_loadTask addItem:[self loadLibraryItem:itemData]];
            }
        }

        [self beginLoad:_loadTask];

        // Resolve all templated items:
        // Iterate through the array as many times as it takes to resolve all template-dependent
        // pages (some templates may themselves have templates in the pendingTemplatedPages).
        // _pendingTemplatedPages can have items added to it during this process.
        BOOL foundTemplate;
        do {
            foundTemplate = NO;
            for (int ii = 0; ii < _loadTask.pendingTemplatedPages.count; ++ii) {
                MTTemplatedPage* tpage = _loadTask.pendingTemplatedPages[ii];
                id<MTPage> tmpl = [self pageWithQualifiedName:tpage.templateName];
                if (tmpl == nil) {
                    continue;
                }
                [self loadPageProps:tpage.page data:tpage.data template:tmpl];
                [_loadTask.pendingTemplatedPages removeObjectAtIndex:ii--];
                foundTemplate = YES;
            }
        } while (foundTemplate);

        // Throw an error if we're missing a template
        if (_loadTask.pendingTemplatedPages.count > 0) {
            MTTemplatedPage* tpage = _loadTask.pendingTemplatedPages[0];
            @throw [MTLoadException withData:tpage.data
                                         reason:@"Missing template '%@'", tpage.templateName];
        }

        // Finalize the load, which resolves all PageRefs
        [self finalizeLoad:_loadTask];

    } @catch (NSException* e) {
        [self abortLoad:_loadTask];
        @throw e;

    } @finally {
        _loadTask = nil;
    }
}

- (id<MTLibraryItem>)loadLibraryItem:(id<MTDataElement>)data {
    // a tome or a page
    MTDataReader* reader = [MTDataReader withData:data];
    NSString* typeName = [reader requireAttribute:TYPE_ATTR];
    NSRange range = [typeName rangeOfString:MT_TOME_PREFIX];
    if (range.location == 0) {
        // it's a tome!
        typeName = [typeName substringFromIndex:range.length];
        Class pageClass = [self requirePageClassWithName:typeName];
        return [self loadTome:data pageClass:pageClass];
    } else {
        // it's a page!
        return [self loadPage:data superclass:nil];
    }
}

- (MTMutableTome*)loadTome:(id<MTDataElement>)tomeData pageClass:(__unsafe_unretained Class)pageClass {
    NSString* name = tomeData.name;
    if (!MTValidLibraryItemName(name)) {
        @throw [MTLoadException withData:tomeData reason:@"tome name '%@' is invalid", name];
    }

    MTMutableTome* tome = [[MTMutableTome alloc] initWithName:name pageClass:pageClass];
    for (id<MTDataElement> pageData in [MTDataReader withData:tomeData].children) {
        id<MTPage> page = [self loadPage:pageData superclass:pageClass];
        [tome addPage:page];
    }

    return tome;
}

- (MTMutablePage*)loadPage:(id<MTDataElement>)pageData superclass:(__unsafe_unretained Class)superclass {
    NSString* name = pageData.name;
    if (!MTValidLibraryItemName(name)) {
        @throw [MTLoadException withData:pageData reason:@"page name '%@' is invalid", name];
    }

    MTDataReader* reader = [MTDataReader withData:pageData];

    NSString* typeName = [reader requireAttribute:TYPE_ATTR];
    Class pageClass = (superclass != nil ?
                       [self requirePageClassWithName:typeName superClass:superclass] :
                       [self requirePageClassWithName:typeName]);

    MTMutablePage* page = [[pageClass alloc] init];
    page.name = name;

    if ([reader hasAttribute:TEMPLATE_ATTR]) {
        // if this page has a template, we defer its loading until the end
        [_loadTask.pendingTemplatedPages addObject:
         [[MTTemplatedPage alloc] initWithPage:page data:pageData]];
    } else {
        [self loadPageProps:page data:reader template:nil];
    }

    return page;
}

- (void)loadPageProps:(MTMutablePage*)page data:(id<MTDataElement>)pageData template:(id<MTPage>)tmpl {
    if (tmpl != nil && ![[tmpl class] isSubclassOfClass:[page class]]) {
        @throw [MTLoadException withData:pageData reason:
                @"Incompatible template [pageName=%@ pageClass=%@ templateName=%@ templateClass=%@]",
                page.name, NSStringFromClass([page class]),
                tmpl.name, NSStringFromClass([tmpl class])];
    }
    
    for (MTProp* prop in page.props) {
        MTProp* tProp = nil;
        if (tmpl != nil) {
            tProp = MTGetProp(tmpl, prop.name);
            if (tProp == nil) {
                @throw [MTLoadException withData:pageData reason:@"Template '%@' missing prop '%@'",
                        tmpl.name, prop.name];
            }
        }
        @try {
            [self loadPageProp:prop templateProp:tProp pageData:pageData];
        } @catch (MTLoadException* e) {
            @throw e;
        } @catch (NSException* e) {
            @throw [MTLoadException withData:pageData reason:@"Error loading prop '%@': %@",
                    prop.name, e.reason];
        }
    }
}

- (void)loadPageProp:(MTProp*)prop templateProp:(MTProp*)tProp pageData:(id<MTDataElement>)pageData {
    MTObjectProp* objectProp =
        ([prop isKindOfClass:[MTObjectProp class]] ? (MTObjectProp*)prop : nil);
    BOOL isPrimitive = (objectProp == nil);

    MTDataReader* pageReader = [MTDataReader withData:pageData];

    if (isPrimitive) {
        // Handle primitive props (read from attributes)
        BOOL useTemplate = (tProp != nil && ![pageReader hasAttribute:prop.name]);

        if ([prop isKindOfClass:[MTIntProp class]]) {
            MTIntProp* intProp = (MTIntProp*)prop;
            if (useTemplate) {
                intProp.value = ((MTIntProp*)tProp).value;
            } else {
                intProp.value = [pageReader requireIntAttribute:prop.name];
                [self.primitiveMarshaller validateInt:intProp];
            }
        } else if ([prop isKindOfClass:[MTBoolProp class]]) {
            MTBoolProp* boolProp = (MTBoolProp*)prop;
            if (useTemplate) {
                boolProp.value = ((MTBoolProp*)tProp).value;
            } else {
                boolProp.value = [pageReader requireBoolAttribute:prop.name];
                [self.primitiveMarshaller validateBool:boolProp];
            }
        } else if ([prop isKindOfClass:[MTFloatProp class]]) {
            MTFloatProp* floatProp = (MTFloatProp*)prop;
            if (useTemplate) {
                floatProp.value = ((MTFloatProp*)tProp).value;
            } else {
                floatProp.value = [pageReader requireFloatAttribute:prop.name];
                [self.primitiveMarshaller validateFloat:floatProp];
            }
        } else {
            @throw [MTLoadException withData:pageData
                                      reason:@"Unrecognized primitive prop [name=%@, class=%@]",
                    prop.name, [prop class]];
        }

    } else {
        // Handle object props (read from child elements)
        MTObjectProp* tObjectProp = (tProp != nil ? (MTObjectProp*)tProp : nil);
        MTDataReader* propReader = [pageReader childNamed:prop.name];
        
        if (propReader == nil) {
            // Handle null object
            if (tObjectProp != nil) {
                // inherit from template
                objectProp.value = tObjectProp.value;
            } else if (objectProp.nullable) {
                // Object is nullable.
                objectProp.value = nil;
            } else {
                @throw [MTLoadException withData:pageData
                                          reason:@"Missing required child [name=%@]", prop.name];
            }
            
        } else {
            // load normally
            id<MTObjectMarshaller> marshaller = [self requireMarshallerForClass:objectProp.valueType.clazz];
            id value = [marshaller withLibrary:self type:objectProp.valueType loadObject:propReader];
            objectProp.value = value;
            [marshaller validatePropValue:objectProp];
        }
    }
}

- (id)objectForKeyedSubscript:(id)key {
    return _items[key];
}

- (void)removeAllItems {
    [_items removeAllObjects];
}

- (void)registerObjectMarshaller:(id<MTObjectMarshaller>)marshaller {
    _objectMarshallers[(id<NSCopying>)marshaller.valueClass] = marshaller;
}

- (id<MTObjectMarshaller>)requireMarshallerForClass:(Class)requiredClass {
    id<MTObjectMarshaller> handler = _objectMarshallers[requiredClass];
    if (handler == nil) {
        // if we can't find an exact match, see if we have a handler for a superclass that
        // can take subclasses
        for (id<MTObjectMarshaller> candidate in _objectMarshallers.objectEnumerator) {
            if (candidate.handlesSubclasses && [requiredClass isSubclassOfClass:candidate.valueClass]) {
                _objectMarshallers[(id<NSCopying>)requiredClass] = candidate;
                handler = candidate;
                break;
            }
        }
    }

    if (handler == nil) {
        [NSException raise:NSGenericException format:@"No handler for '%@'",
            NSStringFromClass(requiredClass)];
    }

    return handler;
}

- (void)registerPageClasses:(NSArray*)classes {
    for (Class pageClass in classes) {
        if (![pageClass conformsToProtocol:@protocol(MTPage)]) {
            [NSException raise:NSGenericException format:@"Class must implement %@ [pageClass=%@]",
             NSStringFromProtocol(@protocol(MTPage)), NSStringFromClass(pageClass)];
        }

        _pageClasses[NSStringFromClass(pageClass)] = pageClass;
    }
}

- (void)beginLoad:(MTLoadTask*)task {
    NSAssert(task.state == MT_Loading, @"task.state != MT_Loading");
    for (id<MTLibraryItem> item in task.libraryItems) {
        if (_items[item.name] != nil) {
            task.state = MT_Aborted;
            [NSException raise:NSGenericException
                        format:@"An item with that name is already loaded [item=%@]", item.name];
        }
    }

    for (id<MTLibraryItem> item in task.libraryItems) {
        _items[item.name] = item;
    }

    task.state = MT_AddedItems;
}

- (void)finalizeLoad:(MTLoadTask*)task {
    NSAssert(task.state == MT_AddedItems, @"task.state != MT_AddedItems");
    @try {
        for (id<MTLibraryItem> item in task.libraryItems) {
            id<MTObjectMarshaller> handler = [self requireMarshallerForClass:[item class]];
            [handler withLibrary:self type:item.type resolveRefs:item];
        }
    }
    @catch (NSException* exception) {
        [self abortLoad:task];
        @throw exception;
    }

    task.state = MT_Finalized;
}

- (void)abortLoad:(MTLoadTask*)task {
    if (task.state == MT_Aborted) {
        return;
    }

    for (id<MTLibraryItem> item in task.libraryItems) {
        [_items removeObjectForKey:item.name];
    }
    task.state = MT_Aborted;
}

- (Class)pageClassWithName:(NSString*)name {
    return _pageClasses[name];
}

- (Class)requirePageClassWithName:(NSString*)name {
    Class clazz = _pageClasses[name];
    if (clazz == nil) {
        @throw [MTLoadException withReason:@"No page class for name [name=%@]", name];
    }
    return clazz;
}

- (Class)requirePageClassWithName:(NSString*)name superClass:(__unsafe_unretained Class)superClass {
    Class clazz = [self requirePageClassWithName:name];
    if (![clazz isSubclassOfClass:superClass]) {
        @throw [MTLoadException withReason:@"Unexpected page class [required=%@, got=%@]",
                NSStringFromClass(superClass), NSStringFromClass(clazz)];
    }
    return clazz;
}

- (id<MTPage>)pageWithQualifiedName:(NSString*)qualifiedName {
    // A page's qualifiedName is a series of page and tome names, separated by dots
    // E.g. level1.baddies.big_boss
    
    NSArray* components = [qualifiedName componentsSeparatedByString:MT_NAME_SEPARATOR];
    id<MTLibraryItem> item = nil;
    for (NSString* name in components) {
        id child = (item != nil ? [item childNamed:name] : self[name]);
        if (![child conformsToProtocol:@protocol(MTLibraryItem)]) {
            return nil;
        }
        item = (id<MTLibraryItem>)child;
    }

    return ([item conformsToProtocol:@protocol(MTPage)] ? (id<MTPage>)item : nil);
}

- (id<MTPage>)requirePageWithQualifiedName:(NSString*)qualifiedName pageClass:(Class)pageClass {
    id<MTPage> page = [self pageWithQualifiedName:qualifiedName];
    if (page == nil) {
        [NSException raise:NSGenericException format:@"Missing required page [name=%@]", qualifiedName];
    }

    if (![page isKindOfClass:pageClass]) {
        [NSException raise:NSGenericException
                    format:@"Wrong type for required page [name=%@ expectedType=%@ actualType=%@]",
                        qualifiedName, NSStringFromClass(pageClass),
                        NSStringFromClass([page class])];
    }

    return page;
}

@end


@implementation MTTemplatedPage

@synthesize page = _page;
@synthesize data = _data;

- (id)initWithPage:(MTMutablePage*)page data:(id<MTDataElement>)data {
    if ((self = [super init])) {
        _page = page;
        _data = [MTDataReader withData:data];
    }
    return self;
}

- (NSString*)templateName {
    return [_data requireAttribute:TEMPLATE_ATTR];
}

@end