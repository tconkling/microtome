//
// microtome - Copyright 2012 Three Rings Design

#import "EnumPage.h"
#import "TestEnum.h"

static NSString* const XML_STRING =
@"<enumTest type='EnumPage'>"
@"  <foo>TWO</foo>"
@"</enumTest>";

static MTObjectPropSpec* _fooSpec = nil;

@implementation EnumPage {
@protected
    MTObjectProp* _foo;
}

+ (NSString*)XML { return XML_STRING; }

- (TestEnum*)foo { return _foo.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTObjectProp alloc] initWithPropSpec:_fooSpec];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_foo);
}

+ (void)initialize {
    if (self == [EnumPage class]) {
        _fooSpec = [[MTObjectPropSpec alloc] initWithName:@"foo" nullable:NO valueType:MTBuildType(@[ [TestEnum class] ])];
    }
}

@end
