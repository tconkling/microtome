//
// microtome - Copyright 2012 Three Rings Design

#import "NestedPage.h"
#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<nestedTest type='NestedPage'>"
    @"  <nested type='PrimitivePage'>"
    @"      <foo>true</foo>"
    @"      <bar>2</bar>"
    @"      <baz>3.1415</baz>"
    @"  </nested>"
    @"</nestedTest>";

@implementation NestedPage {
@protected
    MTMutablePageProp* _nested;
}

+ (NSString*)XML { return XML_STRING; }

- (PrimitivePage*)nested { return _nested.value; }

- (id)init {
    if ((self = [super init])) {
        _nested = [[MTMutablePageProp alloc] initWithName:@"nested" parent:self nullable:NO subType:[PrimitivePage class]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_nested);
}

@end
