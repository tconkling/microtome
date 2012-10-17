//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoader.h"

#import "MTUtils.h"
#import "MTType.h"
#import "MTLibrary.h"
#import "MTXmlObjectMarshaller.h"
#import "MTTome.h"
#import "MTPage.h"
#import "MTPageRef.h"
#import "MTProp.h"
#import "MTXmlLoadException.h"

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

- (void)loadPagesFromDoc:(GDataXMLDocument*)doc {
    [self loadPagesFromDocs:@[doc]];
}

- (void)loadPagesFromDocs:(NSArray*)docs {
    NSMutableArray* pages = [[NSMutableArray alloc] init];
    for (GDataXMLDocument* doc in docs) {
        for (GDataXMLElement* pageXml in doc.rootElement.elements) {
            [pages addObject:[self loadPage:pageXml]];
        }
    }

    [_library addPages:pages];
}

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass {
    id<MTValueHandler> handler = [_library requireValueHandlerForClass:requiredClass];
    if (![handler conformsToProtocol:@protocol(MTXmlObjectMarshaller)]) {
        [NSException raise:NSGenericException format:@"No XML marshaller for '%@'",
            NSStringFromClass(requiredClass)];
    }
    return (id<MTXmlObjectMarshaller>)handler;
}

- (MTMutablePage*)loadPage:(GDataXMLElement*)pageXml requiredClass:(__unsafe_unretained Class)requiredClass {
    NSString* name = pageXml.name;
    if (!MTValidPageName(name)) {
        @throw [MTXmlLoadException withElement:pageXml reason:@"page name '%@' is invalid", name];
    }

    NSString* typeName = [pageXml stringAttribute:@"type"];
    Class pageClass = (requiredClass != nil ?
                       [_library requirePageClassWithName:typeName superClass:requiredClass] :
                       [_library requirePageClassWithName:typeName]);

    MTMutablePage* page = [[pageClass alloc] init];
    page.name = name;
    
    for (MTProp* prop in page.props) {
        MTObjectProp* objectProp =
            ([prop isKindOfClass:[MTObjectProp class]] ? (MTObjectProp*)prop : nil);
        BOOL isPrimitive = (objectProp == nil);
        
        GDataXMLElement* propXml = [pageXml getChild:prop.name];
        if (propXml == nil) {
            if (isPrimitive || !objectProp.nullable) {
                @throw [MTXmlLoadException withElement:pageXml
                            reason:@"Missing required child [name=%@]", prop.name];
            } else {
                // Object is nullable.
                objectProp.value = nil;
            }
            continue;
        }

        @try {
            if (isPrimitive) {
                // Handle primitive props
                if ([prop isKindOfClass:[MTIntProp class]]) {
                    ((MTIntProp*)prop).value = [[self requireTextContent:propXml] requireIntValue];
                } else if ([prop isKindOfClass:[MTBoolProp class]]) {
                    ((MTBoolProp*)prop).value = [[self requireTextContent:propXml] requireBoolValue];
                } else if ([prop isKindOfClass:[MTFloatProp class]]) {
                    ((MTFloatProp*)prop).value = [[self requireTextContent:propXml] requireFloatValue];
                } else {
                    @throw [MTXmlLoadException withElement:propXml
                                reason:@"Unrecognized primitive prop [name=%@, class=%@]",
                                prop.name, [prop class]];
                }

            } else {
                // Handle object props
                id<MTXmlObjectMarshaller> marshaller =
                    [self requireObjectMarshallerForClass:objectProp.valueType.clazz];
                id value = [marshaller withCtx:self type:objectProp.valueType loadObjectfromXml:propXml];
                objectProp.value = value;
            }
        } @catch (MTXmlLoadException* e) {
            @throw e;
        } @catch (NSException* e) {
            @throw [MTXmlLoadException withElement:propXml reason:@"Error loading prop '%@': %@",
                    prop.name, e.reason];
        }
    }
    return page;
}

- (id<MTPage>)loadPage:(GDataXMLElement*)xml {
    return [self loadPage:xml requiredClass:nil];
}

- (NSString*)requireTextContent:(GDataXMLElement*)xml {
    NSString* str = xml.stringValue;
    if (str == nil) {
        @throw [MTXmlLoadException withElement:xml reason:@"Element is empty"];
    }
    return str;
}

@end

