//
// microtome - Copyright 2012 Three Rings Design

#import "TomePage.h"
#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<test type='TomePage'>"
    @"  <tome>"
    @"      <test1 type='PrimitivePage'>"
    @"          <foo>true</foo>"
    @"          <bar>2</bar>"
    @"          <baz>3.1415</baz>"
    @"      </test1>"
    @"      <test2 type='PrimitivePage'>"
    @"          <foo>false</foo>"
    @"          <bar>666</bar>"
    @"          <baz>1.5</baz>"
    @"      </test2>"
    @"  </tome>"
    @"</test>";

@implementation TomePage {
@protected
    MTMutableTomeProp* _tome;
}

+ (NSString*)XML { return XML_STRING; }

- (id<MTTome>)tome { return _tome.value; }

- (id)init {
    if ((self = [super init])) {
        _tome = [[MTMutableTomeProp alloc] initWithName:@"tome" parent:self nullable:NO pageType:[PrimitivePage class]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_tome);
}

@end
