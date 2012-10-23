//
// microtome - Copyright 2012 Three Rings Design

@protocol MTDataElement;

@interface MTLoadException : NSException

+ (MTLoadException*)withReason:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);
+ (MTLoadException*)withData:(id<MTDataElement>)badElement reason:(NSString*)format, ... NS_FORMAT_FUNCTION(2, 3);
- (id)initWithReason:(NSString*)reason;

@end
