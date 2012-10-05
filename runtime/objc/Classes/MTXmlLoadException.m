//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoadException.h"

static NSString * const NAME = @"MTXmlLoadException";

@implementation MTXmlLoadException

+ (MTXmlLoadException*)withReason:(NSString*)format, ... {
    return [[MTXmlLoadException alloc] initWithReason:OOO_FORMAT_TO_NSSTRING(format)];
}

+ (MTXmlLoadException*)withElement:(GDataXMLElement*)badElement reason:(NSString*)format, ... {
    NSString* reason = OOO_FORMAT_TO_NSSTRING(format);

    if (badElement != nil) {
        reason = [NSString stringWithFormat:@"%@\nXML: %@", reason, [badElement description]];
    }

    return [[MTXmlLoadException alloc] initWithReason:reason];
}

- (id)initWithReason:(NSString*)reason {
    return [super initWithName:NAME reason:reason userInfo:nil];
}

@end
