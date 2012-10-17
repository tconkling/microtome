//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoader.h"

@protocol MTXmlObjectMarshaller;
@class MTLibrary;

@interface MTXmlLoader : NSObject <MTLoader> {
@protected
    __weak MTLibrary* _library;
}

@property (nonatomic,readonly) MTLibrary* library;

+ (void)registerDefaultMarshallers:(MTLibrary*)library;

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass;

- (MTMutablePage*)loadPage:(GDataXMLElement*)xml;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml requiredClass:(Class)requiredClass;

@end
