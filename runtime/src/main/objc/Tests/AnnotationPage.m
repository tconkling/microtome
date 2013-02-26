
#import "AnnotationPage.h"
#import "PrimitivePage.h"
#import "microtome.h"

static MTPropSpec* s_fooSpec = nil;
static MTPropSpec* s_barSpec = nil;
static MTPropSpec* s_primitivesSpec = nil;

@implementation AnnotationPage {
@protected
    MTIntProp* _foo;
    MTIntProp* _bar;
    MTObjectProp* _primitives;
}

- (int)foo { return _foo.value; }
- (int)bar { return _bar.value; }
- (PrimitivePage*)primitives { return _primitives.value; }

- (NSArray*)props { return MT_PROPS(_foo, _bar, _primitives, ); }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTIntProp alloc] initWithPropSpec:s_fooSpec];
        _bar = [[MTIntProp alloc] initWithPropSpec:s_barSpec];
        _primitives = [[MTObjectProp alloc] initWithPropSpec:s_primitivesSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [AnnotationPage class]) {
        s_fooSpec = [[MTPropSpec alloc] initWithName:@"foo"
            annotations:@{ @"min":@3.0,@"max":@5.0, }
            valueClasses:nil ];
        s_barSpec = [[MTPropSpec alloc] initWithName:@"bar"
            annotations:@{ @"default":@3.0, }
            valueClasses:nil ];
        s_primitivesSpec = [[MTPropSpec alloc] initWithName:@"primitives"
            annotations:@{ @"nullable":@YES, }
            valueClasses:@[ [PrimitivePage class], ] ];
    }
}

@end
