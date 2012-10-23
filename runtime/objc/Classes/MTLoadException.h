//
// microtome - Copyright 2012 Three Rings Design

@interface MTLoadException : NSException

+ (MTLoadException*)withReason:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);
+ (MTLoadException*)withElement:(GDataXMLElement*)badElement reason:(NSString*)format, ... NS_FORMAT_FUNCTION(2, 3);
- (id)initWithReason:(NSString*)reason;

@end
