//
// microtome - Copyright 2012 Three Rings Design

#import "RefPage.h"
#import "PrimitivePage.h"

static MTPropSpec* _nestedSpec = nil;

@implementation RefPage {
@protected
    MTObjectProp* _nested;
}

- (MTMutablePageRef*)nestedRef { return _nested.value; }
- (PrimitivePage*)nested { return self.nestedRef.page; }

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
    if (self == [RefPage class]) {
        _nestedSpec = [[MTPropSpec alloc] initWithName:@"nested" annotations:nil valueClasses:@[ [MTMutablePageRef class], [PrimitivePage class] ]];
    }
}

@end
