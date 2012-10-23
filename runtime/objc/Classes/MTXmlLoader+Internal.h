//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoader.h"

@interface MTXmlLoader (MTInternal)

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass;

- (MTMutableTome*)loadTome:(GDataXMLElement*)xml pageType:(__unsafe_unretained Class)pageType;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml superclass:(Class)superclass;

@end
