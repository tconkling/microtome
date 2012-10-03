//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlContext.h"

#import "MTXmlPropMarshaller.h"
#import "MTPage.h"
#import "MTProp.h"
#import "MTXmlLoadException.h"

#import "MTIntProp.h"

@implementation MTXmlContext

- (id)init {
    if ((self = [super init])) {
        _marshallers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerPropMarshaller:(id<MTXmlPropMarshaller>)marshaller {
    _marshallers[(id<NSCopying>)marshaller.propClass] = marshaller;
}

- (id<MTPage>)load:(GDataXMLDocument*)xmlDoc {
    id<MTPage> root = [self loadPage:[xmlDoc rootElement]];
    return root;
}

- (id<MTPage>)loadPage:(GDataXMLElement*)xml withRequiredClass:(__unsafe_unretained Class)requiredClass {
    Class pageClass = (requiredClass != nil ?
                       [self requireClassWithName:xml.name superClass:requiredClass] :
                       [self requireClassWithName:xml.name]);

    id<MTPage> page = [[pageClass alloc] init];
    for (id<MTProp> prop in page.props) {
        GDataXMLElement* propXml = [xml getChild:prop.name];
        if (propXml == nil) {
            @throw [MTXmlLoadException withElement:xml
                                            reason:@"Missing required child [name=%@]", prop.name];
        }

        @try {
            if ([prop isKindOfClass:[MTMutableIntProp class]]) {
                [self loadIntProp:(MTMutableIntProp*)prop xml:propXml];
            } else {
                id<MTXmlPropMarshaller> marshaller = _marshallers[[prop class]];
                if (marshaller == nil) {
                    @throw [MTXmlLoadException withElement:xml reason:@"No marshaller for child [name=%@, class=%@]", prop.name, [prop class]];
                }
                [marshaller withCtx:self loadProp:prop fromXml:propXml];
            }
        } @catch (MTXmlLoadException* e) {
            @throw e;
        } @catch (NSException* e) {
            @throw [MTXmlLoadException withElement:propXml reason:@"Error loading prop [name=%@, reason=%@]", prop, e.reason];
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

- (void)loadIntProp:(MTMutableIntProp*)prop xml:(GDataXMLElement*)xml {
    prop.value = [[self requireTextContent:xml] requireIntValue];
}

@end
