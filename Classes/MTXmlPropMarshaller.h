//
// microtome - Copyright 2012 Three Rings Design

@class MTXmlContext;
@protocol MTProp;

@protocol MTXmlPropMarshaller <NSObject>
@property (nonatomic,readonly) Class propClass;
- (void)withCtx:(MTXmlContext*)ctx loadProp:(id<MTProp>)prop fromXml:(GDataXMLElement*)xml;
@end
