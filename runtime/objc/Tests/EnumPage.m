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
    MTObjectProp* _foo;
}

+ (NSString*)XML { return XML_STRING; }

- (TestEnum*)foo { return _foo.value; }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTObjectProp alloc] initWithName:@"foo" nullable:NO valueType:[[MTType alloc] initWithClass:[TestEnum class] subtype:nil]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_foo);
}

@end
