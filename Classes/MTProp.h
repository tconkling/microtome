//
// microtome - Copyright 2012 Three Rings Design

@protocol MTProp <NSObject>

@property (readonly) NSString* name;

- (id)fromXml:(GDataXMLElement*)xml;

@end
