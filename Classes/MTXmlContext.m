//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlContext.h"

#import "MTXmlPropMarshaller.h"
#import "MTPage.h"
#import "MTProp.h"
#import "MTXmlLoadException.h"

#import "MTPrimitiveProps.h"
#import "MTStringProp.h"
#import "MTTomeProp.h"

@interface MTStringPropMarshaller : NSObject <MTXmlPropMarshaller>
@end

@interface MTTomePropMarshaller : NSObject <MTXmlPropMarshaller>
@end

@implementation MTXmlContext

- (id)init {
    if ((self = [super init])) {
        _marshallers = [[NSMutableDictionary alloc] init];
        [self registerPropMarshaller:[[MTStringPropMarshaller alloc] init]];
        [self registerPropMarshaller:[[MTTomePropMarshaller alloc] init]];
    }
    return self;
}

- (void)registerPropMarshaller:(id<MTXmlPropMarshaller>)marshaller {
    _marshallers[(id<NSCopying>)marshaller.propType] = marshaller;
}

- (id<MTPage>)load:(GDataXMLDocument*)xmlDoc {
    id<MTPage> root = [self loadPage:[xmlDoc rootElement]];
    return root;
}

- (id<MTPage>)loadPage:(GDataXMLElement*)pageXml withRequiredClass:(__unsafe_unretained Class)requiredClass {
    Class pageClass = (requiredClass != nil ?
                       [self requireClassWithName:pageXml.name superClass:requiredClass] :
                       [self requireClassWithName:pageXml.name]);

    id<MTPage> page = [[pageClass alloc] init];

    // if this is a named page, parse its name first
    if ([pageClass isSubclassOfClass:[MTMutableNamedPage class]]) {
        ((MTMutableNamedPage*)page).name = [pageXml stringAttribute:@"name"];
    }

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
    return [self loadPage:xml withRequiredClass:nil];
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

- (void)withCtx:(MTXmlContext*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)xml {
    MTMutableStringProp* stringProp = (MTMutableStringProp*)prop;
    stringProp.value = xml.stringValue;

    // handle the empty string (<myStringProp></myStringProp>)
    if (stringProp.value == nil) {
        stringProp.value = @"";
    }
}

@end


@implementation MTTomePropMarshaller

- (Class)propType {
    return [MTMutableTomeProp class];
}

- (void)withCtx:(MTXmlContext*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)tomeXml {
    MTMutableTomeProp* tomeProp = (MTMutableTomeProp*)prop;
    MTMutableTome* tome = [[MTMutableTome alloc] initWithPageType:tomeProp.pageType];
    for (GDataXMLElement* pageXml in tomeXml.elements) {
        id<MTNamedPage> page = (id<MTNamedPage>)[ctx loadPage:pageXml withRequiredClass:tomeProp.pageType];
        [tome addPage:page];
    }
    tomeProp.value = tome;
}

@end

