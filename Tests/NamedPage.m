//
// microtome - Copyright 2012 Three Rings Design

#import "NamedPage.h"

@implementation NamedPage {
@protected
    MTMutableIntProp* _foo;
}

- (int)foo { return _foo.value; }

- (id)init {
    return [super initWithProps:@[
        _foo = [[MTMutableIntProp alloc] initWithName:@"foo"],
    ]];
}

@end
