//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageBase.h"
#import "MTProp.h"

@implementation MTPageBase

@synthesize props = _props;

- (id)initWithProps:(NSArray*)props {
    if ((self = [super init])) {
        _props = props;
    }
    return self;
}

- (id<MTProp>)propNamed:(NSString*)name {
    for (id<MTProp> prop in _props) {
        if ([prop.name isEqualToString:name]) {
            return prop;
        }
    }
    return nil;
}

@end

@implementation MTNamedPageBase

@synthesize name = _name;

- (id)initWithName:(NSString*)name props:(NSArray*)props {
    if ((self = [super initWithProps:props])) {
        _name = name;
    }
    return self;
}

@end
