//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoader.h"

#import "MTUtils.h"
#import "MTLibrary.h"
#import "MTXmlPropMarshaller.h"
#import "MTTome.h"
#import "MTPage.h"
#import "MTPageRef.h"
#import "MTProp.h"
#import "MTXmlLoadException.h"

#import "MTPrimitiveProps.h"
#import "MTPageProp.h"
#import "MTPageRefProp.h"
#import "MTStringProp.h"
#import "MTTomeProp.h"

@interface MTStringPropMarshaller : NSObject <MTXmlPropMarshaller>
@end

@interface MTPagePropMarshaller : NSObject <MTXmlPropMarshaller>
@end

@interface MTPageRefPropMarshaller : NSObject <MTXmlPropMarshaller>
@end

@interface MTTomePropMarshaller : NSObject <MTXmlPropMarshaller>
@end

@implementation MTXmlLoader

- (id)init {
    if ((self = [super init])) {
        _marshallers = [[NSMutableDictionary alloc] init];
        [self registerPropMarshaller:[[MTStringPropMarshaller alloc] init]];
        [self registerPropMarshaller:[[MTPagePropMarshaller alloc] init]];
        [self registerPropMarshaller:[[MTPageRefPropMarshaller alloc] init]];
        [self registerPropMarshaller:[[MTTomePropMarshaller alloc] init]];
    }
    return self;
}

- (void)registerPropMarshaller:(id<MTXmlPropMarshaller>)marshaller {
    _marshallers[(id<NSCopying>)marshaller.propType] = marshaller;
}

- (MTMutablePage*)withLibrary:(MTLibrary*)library loadPage:(id)data {
    NSAssert(_library == nil, @"Already loading");
    NSAssert(library != nil, @"Library cannot be nil");
    NSAssert([data isKindOfClass:[GDataXMLDocument class]], @"data must be a GDataXmlDocument");
    
    @try {
        _library = library;
        return [self loadPage:((GDataXMLDocument*)data).rootElement];
    } @finally {
        _library = nil;
    }
}

- (MTMutablePage*)loadPage:(GDataXMLElement*)pageXml requiredClass:(__unsafe_unretained Class)requiredClass {
    NSString* name = pageXml.name;
    if (!MTValidPageName(name)) {
        @throw [MTXmlLoadException withElement:pageXml reason:@"page name '%@' is invalid", name];
    }

    NSString* typeName = [pageXml stringAttribute:@"type"];
    Class pageClass = (requiredClass != nil ?
                       [_library requireClassWithName:typeName superClass:requiredClass] :
                       [_library requireClassWithName:typeName]);

    MTMutablePage* page = [[pageClass alloc] init];
    page.name = name;
    
    for (id<MTProp> prop in page.props) {
        BOOL isPrimitive = ![prop conformsToProtocol:@protocol(MTMutableObjectProp)];
        id<MTMutableObjectProp> objectProp = (isPrimitive ? nil : (id<MTMutableObjectProp>)prop);
        
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
                if ([prop isKindOfClass:[MTMutableIntProp class]]) {
                    ((MTMutableIntProp*)prop).value = [[self requireTextContent:propXml] requireIntValue];
                } else if ([prop isKindOfClass:[MTMutableBoolProp class]]) {
                    ((MTMutableBoolProp*)prop).value = [[self requireTextContent:propXml] requireBoolValue];
                } else if ([prop isKindOfClass:[MTMutableFloatProp class]]) {
                    ((MTMutableFloatProp*)prop).value = [[self requireTextContent:propXml] requireFloatValue];
                } else {
                    @throw [MTXmlLoadException withElement:propXml
                                reason:@"Unrecognized primitive prop [name=%@, class=%@]",
                                prop.name, [prop class]];
                }

            } else {
                // Handle object props
                id<MTXmlPropMarshaller> marshaller = _marshallers[[prop class]];
                if (marshaller == nil) {
                    @throw [MTXmlLoadException withElement:propXml
                                reason:@"No marshaller for object prop [name=%@, class=%@]",
                                prop.name, [prop class]];
                }
                [marshaller withCtx:self loadProp:objectProp fromXml:propXml];
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


@implementation MTStringPropMarshaller

- (Class)propType {
    return [MTMutableStringProp class];
}

- (void)withCtx:(MTXmlLoader*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)xml {
    MTMutableStringProp* stringProp = (MTMutableStringProp*)prop;
    stringProp.value = xml.stringValue;

    // handle the empty string (<myStringProp></myStringProp>)
    if (stringProp.value == nil) {
        stringProp.value = @"";
    }
}

@end


@implementation MTPagePropMarshaller

- (Class)propType {
    return [MTMutablePageProp class];
}

- (void)withCtx:(MTXmlLoader*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)xml {
    MTMutablePageProp* pageProp = (MTMutablePageProp*)prop;
    id<MTPage> page = [ctx loadPage:xml requiredClass:pageProp.subType];
    pageProp.value = page;
}

@end


@implementation MTPageRefPropMarshaller

- (Class)propType {
    return [MTMutablePageRefProp class];
}

- (void)withCtx:(MTXmlLoader*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)xml {
    MTMutablePageRefProp* refProp = (MTMutablePageRefProp*)prop;
    refProp.value = [[MTMutablePageRef alloc] initWithPageType:refProp.subType
                                                      pageName:xml.stringValue];
}

@end


@implementation MTTomePropMarshaller

- (Class)propType {
    return [MTMutableTomeProp class];
}

- (void)withCtx:(MTXmlLoader*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)tomeXml {
    MTMutableTomeProp* tomeProp = (MTMutableTomeProp*)prop;
    MTMutableTome* tome = [[MTMutableTome alloc] initWithPageType:tomeProp.subType];
    for (GDataXMLElement* pageXml in tomeXml.elements) {
        id<MTPage> page = [ctx loadPage:pageXml requiredClass:tomeProp.subType];
        [tome addPage:page];
    }
    tomeProp.value = tome;
}

@end

