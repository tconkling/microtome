
#import "PrimitivePage.h"
#import "microtome.h"

static MTPropSpec* s_fooSpec = nil;
static MTPropSpec* s_barSpec = nil;
static MTPropSpec* s_bazSpec = nil;

@implementation PrimitivePage {
@protected
    MTBoolProp* _foo;
    MTIntProp* _bar;
    MTFloatProp* _baz;
}

- (BOOL)foo { return _foo.value; }
- (int)bar { return _bar.value; }
- (float)baz { return _baz.value; }

- (NSArray*)props { return MT_PROPS(_foo, _bar, _baz, ); }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTBoolProp alloc] initWithPropSpec:s_fooSpec];
        _bar = [[MTIntProp alloc] initWithPropSpec:s_barSpec];
        _baz = [[MTFloatProp alloc] initWithPropSpec:s_bazSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [PrimitivePage class]) {
        s_fooSpec = [[MTPropSpec alloc] initWithName:@"foo"
            annotations:nil
            valueClasses:nil ];
        s_barSpec = [[MTPropSpec alloc] initWithName:@"bar"
            annotations:nil
            valueClasses:nil ];
        s_bazSpec = [[MTPropSpec alloc] initWithName:@"baz"
            annotations:nil
            valueClasses:nil ];
    }
}

@end
