//
// microtome - Copyright 2012 Three Rings Design

@class MTXmlLoader;
@class MTType;

@protocol MTXmlObjectMarshaller <NSObject>
@property (nonatomic,readonly) Class objectType;
@property (nonatomic,readonly) BOOL handlesSubclasses;
- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml;
@end
