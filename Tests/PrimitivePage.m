//
// microtome - Copyright 2012 Three Rings Design

#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<PrimitivePage>"
    @"  <foo>true</foo>"
    @"  <bar>2</bar>"
    @"  <baz>3.1415</baz>"
    @"</PrimitivePage>";

@implementation PrimitivePage {
@protected
    MTMutableBoolProp* _foo;
    MTMutableIntProp* _bar;
    MTMutableFloatProp* _baz;
    NSArray* _props;
}

@synthesize props = _props;

+ (NSString*)XML { return XML_STRING; }

- (BOOL)foo { return _foo.value; }
- (int)bar { return _bar.value; }
- (float)baz { return _baz.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTMutableBoolProp alloc] initWithName:@"foo"];
        _bar = [[MTMutableIntProp alloc] initWithName:@"bar"];
        _baz = [[MTMutableFloatProp alloc] initWithName:@"baz"];
        _props = @[ _foo, _bar, _baz ];
    }
    return self;
}

@end
