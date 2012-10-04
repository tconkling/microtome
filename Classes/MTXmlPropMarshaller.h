//
// microtome - Copyright 2012 Three Rings Design

@class MTXmlContext;
@protocol MTObjectProp;

@protocol MTXmlPropMarshaller <NSObject>
@property (nonatomic,readonly) Class propClass;
- (void)withCtx:(MTXmlContext*)ctx loadProp:(id<MTObjectProp>)prop fromXml:(GDataXMLElement*)xml;
@end
