//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoader.h"

@class MTLibrary;
@protocol MTXmlPropMarshaller;

@interface MTXmlLoader : NSObject <MTLoader> {
@protected
    MTLibrary* _library;
    NSMutableDictionary* _marshallers;
}

- (void)registerPropMarshaller:(id<MTXmlPropMarshaller>)marshaller;

- (MTMutablePage*)loadPage:(GDataXMLElement*)xml name:(NSString*)name;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml name:(NSString*)name requiredClass:(Class)requiredClass;

@end
