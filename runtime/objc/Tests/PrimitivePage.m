//
// microtome - Copyright 2012 Three Rings Design

#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<primitiveTest type='PrimitivePage'>"
    @"  <foo>true</foo>"
    @"  <bar>2</bar>"
    @"  <baz>3.1415</baz>"
    @"</primitiveTest>";

@implementation PrimitivePage {
@protected
    MTMutableBoolProp* _foo;
    MTMutableIntProp* _bar;
    MTMutableFloatProp* _baz;
}

+ (NSString*)XML { return XML_STRING; }

- (BOOL)foo { return _foo.value; }
- (int)bar { return _bar.value; }
- (float)baz { return _baz.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTMutableBoolProp alloc] initWithName:@"foo" parent:self];
        _bar = [[MTMutableIntProp alloc] initWithName:@"bar" parent:self];
        _baz = [[MTMutableFloatProp alloc] initWithName:@"baz" parent:self];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_foo, _bar, _baz);
}

@end
