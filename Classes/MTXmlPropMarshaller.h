//
// microtome - Copyright 2012 Three Rings Design

@class MTXmlContext;
@protocol MTMutableObjectProp;

@protocol MTXmlPropMarshaller <NSObject>
@property (nonatomic,readonly) Class propType;
- (void)withCtx:(MTXmlContext*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)xml;
@end
