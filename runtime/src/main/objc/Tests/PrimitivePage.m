//
// microtome - Copyright 2012 Three Rings Design

#import "PrimitivePage.h"

static MTPropSpec* _fooSpec = nil;
static MTPropSpec* _barSpec = nil;
static MTPropSpec* _bazSpec = nil;

@implementation PrimitivePage {
@protected
    MTBoolProp* _foo;
    MTIntProp* _bar;
    MTFloatProp* _baz;
}

- (BOOL)foo { return _foo.value; }
- (int)bar { return _bar.value; }
- (float)baz { return _baz.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTBoolProp alloc] initWithPropSpec:_fooSpec];
        _bar = [[MTIntProp alloc] initWithPropSpec:_barSpec];
        _baz = [[MTFloatProp alloc] initWithPropSpec:_bazSpec];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_foo, _bar, _baz);
}

+ (void)initialize {
    if (self == [PrimitivePage class]) {
        _fooSpec = [[MTPropSpec alloc] initWithName:@"foo" annotations:nil valueClasses:nil];
        _barSpec = [[MTPropSpec alloc] initWithName:@"bar" annotations:nil valueClasses:nil];
        _bazSpec = [[MTPropSpec alloc] initWithName:@"baz" annotations:nil valueClasses:nil];
    }
}

@end
