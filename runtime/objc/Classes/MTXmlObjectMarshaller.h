//
// microtome - Copyright 2012 Three Rings Design

#import "MTValueHandler.h"

@class MTXmlLoader;
@class MTType;

/// Extends MTValueHandler with support for loading values from XML
@protocol MTXmlObjectMarshaller <MTObjectValueHandler>
- (id)withLoader:(MTXmlLoader*)loader type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml;
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