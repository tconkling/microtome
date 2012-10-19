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

- (void)loadItemsFromDoc:(GDataXMLDocument*)doc {
    [self loadItemsFromDocs:@[doc]];
}

- (void)loadItemsFromDocs:(NSArray*)docs {
    NSMutableArray* pages = [[NSMutableArray alloc] init];
    for (GDataXMLDocument* doc in docs) {
        for (GDataXMLElement* pageXml in doc.rootElement.elements) {
            [pages addObject:[self loadLibraryItem:pageXml]];
        }
    }

    [_library addItems:pages];
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
    NSString* typeName = [xml stringAttribute:@"type"];
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

    NSString* typeName = [pageXml stringAttribute:@"type"];
    Class pageClass = (superclass != nil ?
                       [_library requirePageClassWithName:typeName superClass:superclass] :
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
                    MTIntProp* intProp = (MTIntProp*)prop;
                    intProp.value = MTRequireIntValue([self requireTextContent:propXml]);
                    [_library.primitiveValueHandler validateInt:intProp];
                } else if ([prop isKindOfClass:[MTBoolProp class]]) {
                    MTBoolProp* boolProp = (MTBoolProp*)prop;
                    boolProp.value = MTRequireBoolValue([self requireTextContent:propXml]);
                    [_library.primitiveValueHandler validateBool:boolProp];
                } else if ([prop isKindOfClass:[MTFloatProp class]]) {
                    MTFloatProp* floatProp = (MTFloatProp*)prop;
                    floatProp.value = MTRequireFloatValue([self requireTextContent:propXml]);
                    [_library.primitiveValueHandler validateFloat:floatProp];
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
                [marshaller validatePropValue:objectProp];
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

- (NSString*)requireTextContent:(GDataXMLElement*)xml {
    NSString* str = xml.stringValue;
    if (str == nil) {
        @throw [MTXmlLoadException withElement:xml reason:@"Element is empty"];
    }
    return str;
}

@end

