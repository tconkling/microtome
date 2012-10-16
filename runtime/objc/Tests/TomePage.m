//
// microtome - Copyright 2012 Three Rings Design

#import "TomePage.h"
#import "PrimitivePage.h"
#import "MTTomeProp.h"

static NSString* const XML_STRING =
    @"<tomeTest type='TomePage'>"
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
    @"</tomeTest>";

@implementation TomePage {
@protected
    MTTomeProp* _tome;
}

+ (NSString*)XML { return XML_STRING; }

- (id<MTTome>)tome { return _tome.value; }

- (id)init {
    if ((self = [super init])) {
        _tome = [[MTTomeProp alloc] initWithName:@"tome" nullable:NO subType:[PrimitivePage class]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_tome);
}

@end
