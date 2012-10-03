//
// microtome - Copyright 2012 Three Rings Design

#import "MTContext.h"

@protocol MTPage;
@protocol MTXmlPropMarshaller;

@interface MTXmlContext : MTContext {
@protected
    NSMutableDictionary* _marshallers;
}

- (void)registerPropMarshaller:(id<MTXmlPropMarshaller>)marshaller;

- (id<MTPage>)load:(GDataXMLDocument*)xmlDoc;

- (id<MTPage>)loadPage:(GDataXMLElement*)xml;
- (id<MTPage>)loadPage:(GDataXMLElement*)xml withRequiredClass:(Class)requiredClass;

@end
