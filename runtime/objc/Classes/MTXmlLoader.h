//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoader.h"

@class MTLibrary;
@protocol MTXmlObjectMarshaller;

@interface MTXmlLoader : NSObject <MTLoader> {
@protected
    MTLibrary* _library;
    NSMutableDictionary* _marshallers;
}

- (void)registerObjectMarshaller:(id<MTXmlObjectMarshaller>)marshaller;

- (MTMutablePage*)loadPage:(GDataXMLElement*)xml;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml requiredClass:(Class)requiredClass;

@end
