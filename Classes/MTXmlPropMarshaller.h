//
// microtome - Copyright 2012 Three Rings Design

@class MTXmlLoader;
@protocol MTMutableObjectProp;

@protocol MTXmlPropMarshaller <NSObject>
@property (nonatomic,readonly) Class propType;
- (void)withCtx:(MTXmlLoader*)ctx loadProp:(id<MTMutableObjectProp>)prop fromXml:(GDataXMLElement*)xml;
@end
