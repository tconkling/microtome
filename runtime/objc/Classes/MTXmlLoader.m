//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoader.h"

#import "MTDefs.h"
#import "MTUtils.h"
#import "MTType.h"
#import "MTLibrary.h"
#import "MTXmlObjectMarshaller.h"
#import "MTMutableTome.h"
#import "MTMutablePage.h"
#import "MTMutablePageRef.h"
#import "MTProp.h"
#import "MTXmlLoadException.h"

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

/// LoadTask

@interface MTXmlLoadTask : NSObject {
@protected
    NSMutableArray* _libraryItems;
    NSMutableArray* _pendingTemplatedPages;
}

@property (nonatomic,readonly) NSMutableArray* libraryItems;
@property (nonatomic,readonly) NSMutableArray* pendingTemplatedPages;
@end

/// Loader

@implementation MTXmlLoader

- (id)initWithLibrary:(MTLibrary*)library {
    if ((self = [super init])) {
        _library = library;

        [library registerValueHandler:[[MTStringMarshaller alloc] init]];
        [library registerValueHandler:[[MTListMarshaller alloc] init]];
        [library registerValueHandler:[[MTPageMarshaller alloc] init]];
        [library registerValueHandler:[[MTPageRefMarshaller alloc] init]];
        [library registerValueHandler:[[MTTomeMarshaller alloc] init]];
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
    _loadTask = [[MTXmlLoadTask alloc] init];
    
    for (GDataXMLDocument* doc in docs) {
        for (GDataXMLElement* pageXml in doc.rootElement.elements) {
            [_loadTask.libraryItems addObject:[self loadLibraryItem:pageXml]];
        }
    }

    [_library addItems:_loadTask.libraryItems];

    // resolve all templated items
    @try {
        // Iterate through the array as many times as it takes to resolve
        // the templates (some templates may themselves have templates in the pendingTemplatedPages)
        // Throw an error if we have a complete iteration with no resolution
        BOOL foundTemplate;
        do {
            foundTemplate = NO;
            for (int ii = 0; ii < _loadTask.pendingTemplatedPages.count; ++ii) {
                MTTemplatedPage* tpage = _loadTask.pendingTemplatedPages[ii];
                NSString* templateName = [tpage.xml stringAttribute:TEMPLATE_ATTR];
                id<MTPage> page = [_library getPage:templateName];
                if (page != nil) {
                    continue;
                }
                foundTemplate = YES;
            }
        } while (foundTemplate);
    }
    @catch (NSException *exception) {
    }

    _loadTask = nil;
}

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass {
    id<MTValueHandler> handler = [_library requireValueHandlerForClass:requiredClass];
    if (![handler conformsToProtocol:@protocol(MTXmlObjectMarshaller)]) {
        [NSException raise:NSGenericException format:@"No XML marshaller for '%@'",
            NSStringFromClass(requiredClass)];
    }
    return (id<MTXmlObjectMarshaller>)handler;
}

- (id<MTLibraryItem>)loadLibraryItem:(GDataXMLElement*)xml {
    // a tome or a page
    NSString* typeName = [xml stringAttribute:TYPE_ATTR];
    NSRange range = [typeName rangeOfString:MT_TOME_PREFIX];
    if (range.location == 0) {
        // it's a tome!
        typeName = [typeName substringFromIndex:range.length];
        Class pageClass = [_library requirePageClassWithName:typeName];
        return [self loadTome:xml pageType:pageClass];
    } else {
        // it's a page!
        return [self loadPage:xml superclass:nil];
    }
}

- (MTMutableTome*)loadTome:(GDataXMLElement*)tomeXml pageType:(__unsafe_unretained Class)pageType {
    NSString* name = tomeXml.name;
    if (!MTValidLibraryItemName(name)) {
        @throw [MTXmlLoadException withElement:tomeXml reason:@"tome name '%@' is invalid", name];
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
        @throw [MTXmlLoadException withElement:pageXml reason:@"page name '%@' is invalid", name];
    }

    NSString* typeName = [pageXml stringAttribute:TYPE_ATTR];
    Class pageClass = (superclass != nil ?
                       [_library requirePageClassWithName:typeName superClass:superclass] :
                       [_library requirePageClassWithName:typeName]);

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

- (void)loadPageProps:(MTMutablePage*)page xml:(GDataXMLElement*)pageXml template:(MTMutablePage*)template {
    if (template != nil && [[template class] isSubclassOfClass:[page class]]) {
        @throw [MTXmlLoadException withElement:pageXml reason:
                @"Incompatible template [pageName=%@ pageClass=%@ templateName=%@ templateClass=%@]",
                    page.name, NSStringFromClass([page class]),
                    template.name, NSStringFromClass([template class])];
    }
    for (MTProp* prop in page.props) {
        MTObjectProp* objectProp =
        ([prop isKindOfClass:[MTObjectProp class]] ? (MTObjectProp*)prop : nil);
        BOOL isPrimitive = (objectProp == nil);

        MTProp* tProp = (template != nil ? MTGetProp(template, prop.name) : nil);

        if (isPrimitive) {
            // Handle primitive props (read from attributes)
            @try {
                BOOL useTemplate = (tProp != nil && ![pageXml hasAttribute:prop.name]);

                if ([prop isKindOfClass:[MTIntProp class]]) {
                    MTIntProp* intProp = (MTIntProp*)prop;
                    if (useTemplate) {
                        intProp.value = ((MTIntProp*)prop).value;
                    } else {
                        intProp.value = [pageXml intAttribute:prop.name];
                        [_library.primitiveValueHandler validateInt:intProp];
                    }
                } else if ([prop isKindOfClass:[MTBoolProp class]]) {
                    MTBoolProp* boolProp = (MTBoolProp*)prop;
                    if (useTemplate) {
                        boolProp.value = ((MTBoolProp*)prop).value;
                    } else {
                        boolProp.value = [pageXml boolAttribute:prop.name];
                        [_library.primitiveValueHandler validateBool:boolProp];
                    }
                } else if ([prop isKindOfClass:[MTFloatProp class]]) {
                    MTFloatProp* floatProp = (MTFloatProp*)prop;
                    if (useTemplate) {
                        floatProp.value = ((MTFloatProp*)prop).value;
                    } else {
                        floatProp.value = [pageXml floatAttribute:prop.name];
                        [_library.primitiveValueHandler validateFloat:floatProp];
                    }
                } else {
                    @throw [MTXmlLoadException withElement:pageXml
                                                    reason:@"Unrecognized primitive prop [name=%@, class=%@]",
                            prop.name, [prop class]];
                }
            } @catch (MTXmlLoadException* e) {
                @throw e;
            } @catch (NSException* e) {
                @throw [MTXmlLoadException withElement:pageXml reason:@"Error loading prop '%@': %@",
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
                        @throw [MTXmlLoadException withElement:pageXml
                                    reason:@"Missing required child [name=%@]", prop.name];
                    }
                    continue;
                }
                
                id<MTXmlObjectMarshaller> marshaller =
                    [self requireObjectMarshallerForClass:objectProp.valueType.clazz];
                id value = [marshaller withLoader:self type:objectProp.valueType loadObjectfromXml:propXml];
                objectProp.value = value;
                [marshaller validatePropValue:objectProp];
            } @catch (MTXmlLoadException* e) {
                @throw e;
            } @catch (NSException* e) {
                @throw [MTXmlLoadException withElement:propXml reason:@"Error loading prop '%@': %@",
                        prop.name, e.reason];
            }
        }
    }
}

- (NSString*)requireTextContent:(GDataXMLElement*)xml {
    NSString* str = xml.stringValue;
    if (str == nil) {
        @throw [MTXmlLoadException withElement:xml reason:@"Element is empty"];
    }
    return str;
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

@end

@implementation MTXmlLoadTask

@synthesize libraryItems = _libraryItems;
@synthesize pendingTemplatedPages = _pendingTemplatedPages;

- (id)init {
    if ((self = [super init])) {
        _libraryItems = [[NSMutableArray alloc] init];
        _pendingTemplatedPages = [[NSMutableArray alloc] init];
    }
    return self;
}

@end        