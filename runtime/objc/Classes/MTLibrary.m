//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary+Internal.h"

#import "MTDefs.h"
#import "MTUtils.h"
#import "MTType.h"
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
    GDataXMLElement* _xml;
}
@property (nonatomic,readonly) MTMutablePage* page;
@property (nonatomic,readonly) GDataXMLElement* xml;
@property (nonatomic,readonly) NSString* templateName;

- (id)initWithPage:(MTMutablePage*)page xml:(GDataXMLElement*)xml;
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

- (void)loadFiles:(NSArray*)filenames {
    NSMutableArray* docs = [[NSMutableArray alloc] initWithCapacity:filenames.count];
    for (NSString* filename in filenames) {
        NSData* data = [NSData dataWithContentsOfFile:filename];
        if (data == nil) {
            [NSException raise:NSGenericException format:@"Unable to load file '%@'", filename];
        }

        NSError* err;
        GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        if (doc == nil) {
            @throw [[NSException alloc] initWithName:NSGenericException
                                              reason:[err localizedDescription]
                                            userInfo:[err userInfo]];
        }
        [docs addObject:doc];
    }

    [self loadXmlDocs:docs];
}

- (void)loadXmlDocs:(NSArray*)docs {
    NSAssert(_loadTask == nil, @"Load already in progress!");
    _loadTask = [[MTLoadTask alloc] init];

    @try {
        for (GDataXMLDocument* doc in docs) {
            for (GDataXMLElement* pageXml in doc.rootElement.elements) {
                [_loadTask addItem:[self loadLibraryItem:pageXml]];
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
                [self loadPageProps:tpage.page xml:tpage.xml template:tmpl];
                [_loadTask.pendingTemplatedPages removeObjectAtIndex:ii--];
                foundTemplate = YES;
            }
        } while (foundTemplate);

        // Throw an error if we're missing a template
        if (_loadTask.pendingTemplatedPages.count > 0) {
            MTTemplatedPage* tpage = _loadTask.pendingTemplatedPages[0];
            @throw [MTLoadException withElement:tpage.xml
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

- (id<MTLibraryItem>)loadLibraryItem:(GDataXMLElement*)xml {
    // a tome or a page
    NSString* typeName = [xml stringAttribute:TYPE_ATTR];
    NSRange range = [typeName rangeOfString:MT_TOME_PREFIX];
    if (range.location == 0) {
        // it's a tome!
        typeName = [typeName substringFromIndex:range.length];
        Class pageClass = [self requirePageClassWithName:typeName];
        return [self loadTome:xml pageType:pageClass];
    } else {
        // it's a page!
        return [self loadPage:xml superclass:nil];
    }
}

- (MTMutableTome*)loadTome:(GDataXMLElement*)tomeXml pageType:(__unsafe_unretained Class)pageType {
    NSString* name = tomeXml.name;
    if (!MTValidLibraryItemName(name)) {
        @throw [MTLoadException withElement:tomeXml reason:@"tome name '%@' is invalid", name];
    }

    MTMutableTome* tome = [[MTMutableTome alloc] initWithName:name pageType:pageType];
    for (GDataXMLElement* pageXml in tomeXml.elements) {
        id<MTPage> page = [self loadPage:pageXml superclass:pageType];
        [tome addPage:page];
    }

    return tome;
}

- (MTMutablePage*)loadPage:(GDataXMLElement*)pageXml superclass:(__unsafe_unretained Class)superclass {
    NSString* name = pageXml.name;
    if (!MTValidLibraryItemName(name)) {
        @throw [MTLoadException withElement:pageXml reason:@"page name '%@' is invalid", name];
    }

    NSString* typeName = [pageXml stringAttribute:TYPE_ATTR];
    Class pageClass = (superclass != nil ?
                       [self requirePageClassWithName:typeName superClass:superclass] :
                       [self requirePageClassWithName:typeName]);

    MTMutablePage* page = [[pageClass alloc] init];
    page.name = name;

    if ([pageXml hasAttribute:TEMPLATE_ATTR]) {
        // if this page has a template, we defer its loading until the end
        [_loadTask.pendingTemplatedPages addObject:
         [[MTTemplatedPage alloc] initWithPage:page xml:pageXml]];
    } else {
        [self loadPageProps:page xml:pageXml template:nil];
    }

    return page;
}

- (void)loadPageProps:(MTMutablePage*)page xml:(GDataXMLElement*)pageXml template:(id<MTPage>)tmpl {
    if (tmpl != nil && ![[tmpl class] isSubclassOfClass:[page class]]) {
        @throw [MTLoadException withElement:pageXml reason:
                @"Incompatible template [pageName=%@ pageClass=%@ templateName=%@ templateClass=%@]",
                page.name, NSStringFromClass([page class]),
                tmpl.name, NSStringFromClass([tmpl class])];
    }
    for (MTProp* prop in page.props) {
        MTObjectProp* objectProp =
        ([prop isKindOfClass:[MTObjectProp class]] ? (MTObjectProp*)prop : nil);
        BOOL isPrimitive = (objectProp == nil);

        MTProp* tProp = (tmpl != nil ? MTGetProp(tmpl, prop.name) : nil);

        if (isPrimitive) {
            // Handle primitive props (read from attributes)
            @try {
                BOOL useTemplate = (tProp != nil && ![pageXml hasAttribute:prop.name]);

                if ([prop isKindOfClass:[MTIntProp class]]) {
                    MTIntProp* intProp = (MTIntProp*)prop;
                    if (useTemplate) {
                        intProp.value = ((MTIntProp*)tProp).value;
                    } else {
                        intProp.value = [pageXml intAttribute:prop.name];
                        [self.primitiveMarshaller validateInt:intProp];
                    }
                } else if ([prop isKindOfClass:[MTBoolProp class]]) {
                    MTBoolProp* boolProp = (MTBoolProp*)prop;
                    if (useTemplate) {
                        boolProp.value = ((MTBoolProp*)tProp).value;
                    } else {
                        boolProp.value = [pageXml boolAttribute:prop.name];
                        [self.primitiveMarshaller validateBool:boolProp];
                    }
                } else if ([prop isKindOfClass:[MTFloatProp class]]) {
                    MTFloatProp* floatProp = (MTFloatProp*)prop;
                    if (useTemplate) {
                        floatProp.value = ((MTFloatProp*)tProp).value;
                    } else {
                        floatProp.value = [pageXml floatAttribute:prop.name];
                        [self.primitiveMarshaller validateFloat:floatProp];
                    }
                } else {
                    @throw [MTLoadException withElement:pageXml
                                                 reason:@"Unrecognized primitive prop [name=%@, class=%@]",
                            prop.name, [prop class]];
                }
            } @catch (MTLoadException* e) {
                @throw e;
            } @catch (NSException* e) {
                @throw [MTLoadException withElement:pageXml reason:@"Error loading prop '%@': %@",
                        prop.name, e.reason];
            }

        } else {
            // Handle object props (read from child elements)
            MTObjectProp* tObjectProp = (tProp != nil ? (MTObjectProp*)tProp : nil);
            GDataXMLElement* propXml = [pageXml getChild:prop.name];
            @try {
                // Handle null objects
                if (propXml == nil) {
                    if (tObjectProp != nil) {
                        // inherit from template
                        objectProp.value = tObjectProp.value;
                    } else if (objectProp.nullable) {
                        // Object is nullable.
                        objectProp.value = nil;
                    } else {
                        @throw [MTLoadException withElement:pageXml
                                                     reason:@"Missing required child [name=%@]", prop.name];
                    }
                    continue;
                }

                id<MTObjectMarshaller> marshaller = [self requireMarshallerForClass:objectProp.valueType.clazz];
                id value = [marshaller withLibrary:self type:objectProp.valueType loadObjectfromXml:propXml];
                objectProp.value = value;
                [marshaller validatePropValue:objectProp];
            } @catch (MTLoadException* e) {
                @throw e;
            } @catch (NSException* e) {
                @throw [MTLoadException withElement:propXml reason:@"Error loading prop '%@': %@",
                        prop.name, e.reason];
            }
        }
    }
}

- (NSString*)requireTextContent:(GDataXMLElement*)xml {
    NSString* str = xml.stringValue;
    if (str == nil) {
        @throw [MTLoadException withElement:xml reason:@"Element is empty"];
    }
    return str;
}

- (id)objectForKeyedSubscript:(id)key {
    return _items[key];
}

- (void)removeAllItems {
    [_items removeAllObjects];
}

- (void)registerObjectMarshaller:(id<MTObjectMarshaller>)marshaller {
    _objectMarshallers[(id<NSCopying>)marshaller.valueType] = marshaller;
}

- (id<MTObjectMarshaller>)requireMarshallerForClass:(Class)requiredClass {
    id<MTObjectMarshaller> handler = _objectMarshallers[requiredClass];
    if (handler == nil) {
        // if we can't find an exact match, see if we have a handler for a superclass that
        // can take subclasses
        for (id<MTObjectMarshaller> candidate in _objectMarshallers.objectEnumerator) {
            if (candidate.handlesSubclasses && [requiredClass isSubclassOfClass:candidate.valueType]) {
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
@synthesize xml = _xml;

- (id)initWithPage:(MTMutablePage*)page xml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        _page = page;
        _xml = xml;
    }
    return self;
}

- (NSString*)templateName {
    return [_xml stringAttribute:TEMPLATE_ATTR];
}

@end