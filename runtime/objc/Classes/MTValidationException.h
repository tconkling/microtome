//
// microtome - Copyright 2012 Three Rings Design

@class MTProp;

@interface MTValidationException : NSException {
@protected
    MTProp* _prop;
}

+ (MTValidationException*)withProp:(MTProp*)prop reason:(NSString*)format, ... NS_FORMAT_FUNCTION(2, 3);
- (id)initWithProp:(MTProp*)prop reason:(NSString*)reason;

@end
