//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@implementation MTPropBase

@synthesize name = _name;

- (id)initWithName:(NSString*)name hasDefault:(BOOL)hasDefault {
    if ((self = [super init])) {
        _name = name;
        _hasDefault = hasDefault;
    }
    return self;
}

- (id)fromXml:(GDataXMLElement*)xml {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
