//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLibrary.h"
#import "MTLibrary+Internal.h"

@interface MTXmlLibrary (MTInternal)

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass;

- (MTMutableTome*)loadTome:(GDataXMLElement*)xml pageType:(__unsafe_unretained Class)pageType;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml superclass:(Class)superclass;

@end
