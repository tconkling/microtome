//
// microtome - Copyright 2012 Three Rings Design

#import "EnumPage.h"
#import "TestEnum.h"

static NSString* const XML_STRING =
@"<enumTest type='EnumPage'>"
@"  <foo>TWO</foo>"
@"</enumTest>";

@implementation EnumPage {
@protected
    MTEnumProp* _foo;
}

+ (NSString*)XML { return XML_STRING; }

- (TestEnum*)foo { return _foo.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTEnumProp alloc] initWithName:@"foo" nullable:NO subType:[TestEnum class]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_foo);
}

@end
