//
// cooocoa - Copyright 2012 Three Rings Design

@class GDataXMLElement;

@interface GDataXMLException : NSException

+ (GDataXMLException*)withReason:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);
+ (GDataXMLException*)withElement:(GDataXMLElement*)badElement reason:(NSString*)format, ... NS_FORMAT_FUNCTION(2, 3);
- (id)initWithReason:(NSString*)reason;

@end
