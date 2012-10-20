//
// microtome - Copyright 2012 Three Rings Design

#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<root><primitiveTest type='PrimitivePage' foo='true' bar='2' baz='3.1415'/></root>";

static MTPropSpec* _fooSpec = nil;
static MTPropSpec* _barSpec = nil;
static MTPropSpec* _bazSpec = nil;

@implementation PrimitivePage {
@protected
    MTBoolProp* _foo;
    MTIntProp* _bar;
    MTFloatProp* _baz;
}

+ (NSString*)XML { return XML_STRING; }

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
        _fooSpec = [[MTPropSpec alloc] initWithName:@"foo" annotations:nil valueTypes:nil];
        _barSpec = [[MTPropSpec alloc] initWithName:@"bar" annotations:nil valueTypes:nil];
        _bazSpec = [[MTPropSpec alloc] initWithName:@"baz" annotations:nil valueTypes:nil];
    }
}

@end
