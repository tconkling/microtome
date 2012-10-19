//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoadException.h"

#import "MTDefs.h"

static NSString * const NAME = @"MTXmlLoadException";

@implementation MTXmlLoadException

+ (MTXmlLoadException*)withReason:(NSString*)format, ... {
    return [[MTXmlLoadException alloc] initWithReason:MT_FORMAT_TO_NSSTRING(format)];
}

+ (MTXmlLoadException*)withElement:(GDataXMLElement*)badElement reason:(NSString*)format, ... {
    NSString* reason = MT_FORMAT_TO_NSSTRING(format);

    if (badElement != nil) {
        reason = [NSString stringWithFormat:@"%@\nXML: %@", reason, [badElement description]];
    }

    return [[MTXmlLoadException alloc] initWithReason:reason];
}

- (id)initWithReason:(NSString*)reason {
    return [super initWithName:NAME reason:reason userInfo:nil];
}

@end
