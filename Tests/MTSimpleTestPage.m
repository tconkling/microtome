//
// microtome - Copyright 2012 Three Rings Design

#import "MTSimpleTestPage.h"

@implementation MTSimpleTestPage {
@protected
    MTMutableIntProp* _foo;
    NSArray* _props;
}

@synthesize props = _props;

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTMutableIntProp alloc] initWithName:@"foo"];
        _props = @[ _foo ];
    }
    return self;
}

- (int)foo { return _foo.value; }

@end
