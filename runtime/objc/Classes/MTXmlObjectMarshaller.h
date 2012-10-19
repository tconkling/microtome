//
// microtome - Copyright 2012 Three Rings Design

#import "MTValueHandler.h"

@class MTXmlLoader;
@class MTType;
@class GDataXMLElement;

/// Extends MTValueHandler with support for loading values from XML
@protocol MTXmlObjectMarshaller <MTValueHandler>
- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml;
@end

// built-in marshallers

@interface MTStringMarshaller : MTStringValueHandler <MTXmlObjectMarshaller>
@end

@interface MTListMarshaller : MTListValueHandler <MTXmlObjectMarshaller>
@end

@interface MTPageMarshaller : MTPageValueHandler <MTXmlObjectMarshaller>
@end

@interface MTPageRefMarshaller : MTPageRefValueHandler <MTXmlObjectMarshaller>
@end

@interface MTTomeMarshaller : MTTomeValueHandler <MTXmlObjectMarshaller>
@end