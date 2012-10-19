//
// microtome - Copyright 2012 Three Rings Design

#import "MTValidationException.h"

#import "MTProp.h"

static NSString* const NAME = @"MTValidationException";

@implementation MTValidationException

+ (MTValidationException*)withProp:(MTProp*)prop reason:(NSString *)format, ... {
    return [[MTValidationException alloc] initWithProp:prop reason:OOO_FORMAT_TO_NSSTRING(format)];
}

- (id)initWithProp:(MTProp*)prop reason:(NSString*)reason {
    return [super initWithName:NAME
                        reason:[NSString stringWithFormat:@"Error validating '%@': %@", prop.name, reason]
                      userInfo:nil];
}

@end
