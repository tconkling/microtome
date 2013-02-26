
#import "RefPage.h"
#import "MTPageRef.h"
#import "PrimitivePage.h"
#import "microtome.h"

static MTPropSpec* s_nestedSpec = nil;

@implementation RefPage {
@protected
    MTObjectProp* _nested;
}

- (PrimitivePage*)nested { return ((MTPageRef*) _nested.value).page; }

- (NSArray*)props { return MT_PROPS(_nested, ); }

- (id)init {
    if ((self = [super init])) {
        _nested = [[MTObjectProp alloc] initWithPropSpec:s_nestedSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [RefPage class]) {
        s_nestedSpec = [[MTPropSpec alloc] initWithName:@"nested"
            annotations:nil
            valueClasses:@[ [MTPageRef class],[PrimitivePage class], ] ];
    }
}

@end
