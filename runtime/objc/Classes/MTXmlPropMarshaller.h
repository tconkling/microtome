//
// microtome - Copyright 2012 Three Rings Design

@class MTXmlLoader;
@protocol MTObjectProp;

@protocol MTXmlPropMarshaller <NSObject>
@property (nonatomic,readonly) Class propType;
- (void)withCtx:(MTXmlLoader*)ctx loadProp:(id<MTObjectProp>)prop fromXml:(GDataXMLElement*)xml;
@end
