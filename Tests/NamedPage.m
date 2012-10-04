//
// microtome - Copyright 2012 Three Rings Design

#import "NamedPage.h"

@implementation NamedPage {
@protected
    MTMutableIntProp* _foo;
}

- (int)foo { return _foo.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTMutableIntProp alloc] initWithName:@"foo"];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_foo);
}

@end
