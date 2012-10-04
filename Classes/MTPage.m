//
// microtome - Copyright 2012 Three Rings Design

#import "MTPage.h"

@implementation MTMutablePage

@synthesize props = _props;

- (id)initWithProps:(NSArray*)props {
    if ((self = [super init])) {
        _props = props;
    }
    return self;
}

@end

@implementation MTMutableNamedPage

@synthesize name = _name;

@end