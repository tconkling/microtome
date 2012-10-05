//
// microtome - Copyright 2012 Three Rings Design

@interface MTLoadException : NSException

+ (MTLoadException*)withReason:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);
- (id)initWithReason:(NSString*)reason;

@end
