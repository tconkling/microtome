//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoadException.h"
#import "MTDefs.h"

static NSString* const NAME = @"MTLoadException";

@implementation MTLoadException

+ (MTLoadException*)withReason:(NSString*)format, ... {
    return [[MTLoadException alloc] initWithReason:MT_FORMAT_TO_NSSTRING(format)];
}

- (id)initWithReason:(NSString*)reason {
    return [super initWithName:NAME reason:reason userInfo:nil];
}

@end
