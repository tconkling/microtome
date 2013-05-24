
#import "NestedPage.h"
#import "PrimitivePage.h"
#import "microtome.h"

static MTPropSpec* s_nestedSpec = nil;

@implementation NestedPage {
@protected
    MTObjectProp* _nested;
}

- (PrimitivePage*)nested { return _nested.value; }

- (NSArray*)props { return MT_PROPS(_nested, ); }

- (id)init {
    if ((self = [super init])) {
        _nested = [[MTObjectProp alloc] initWithPropSpec:s_nestedSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [NestedPage class]) {
        s_nestedSpec = [[MTPropSpec alloc] initWithName:@"nested"
            annotations:nil
            valueClasses:@[ [PrimitivePage class], ] ];
    }
}

@end
