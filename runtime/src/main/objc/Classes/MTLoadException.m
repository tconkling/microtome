//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoadException.h"

#import "MTDataElement.h"
#import "MTDefs.h"

static NSString* const NAME = @"MTLoadException";

@implementation MTLoadException

+ (MTLoadException*)withReason:(NSString*)format, ... {
    return [[MTLoadException alloc] initWithReason:MT_FORMAT_TO_NSSTRING(format)];
}

+ (MTLoadException*)withData:(id<MTDataElement>)badElement reason:(NSString*)format, ... {
    NSString* reason = MT_FORMAT_TO_NSSTRING(format);

    if (badElement != nil) {
        reason = [NSString stringWithFormat:@"%@ data:\n%@", reason, badElement.description];
    }

    return [[MTLoadException alloc] initWithReason:reason];
}

- (id)initWithReason:(NSString*)reason {
    return [super initWithName:NAME reason:reason userInfo:nil];
}

@end
