//
// microtome - Copyright 2012 Three Rings Design

#import "NestedPage.h"
#import "PrimitivePage.h"

static MTPropSpec* _nestedSpec = nil;

@implementation NestedPage {
@protected
    MTObjectProp* _nested;
}

- (PrimitivePage*)nested { return _nested.value; }

- (id)init {
    if ((self = [super init])) {
        _nested = [[MTObjectProp alloc] initWithPropSpec:_nestedSpec];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_nested);
}

+ (void)initialize {
    if (self == [NestedPage class]) {
        _nestedSpec = [[MTPropSpec alloc] initWithName:@"nested" annotations:nil valueClasses:@[[PrimitivePage class]]];
    }
}

@end
