//
// microtome - Copyright 2012 Three Rings Design

#import "TomePage.h"
#import "NamedPage.h"

static NSString* const XML_STRING =
    @"<TomePage>"
    @"  <tome>"
    @"      <NamedPage name='test1'>"
    @"          <foo>1</foo>"
    @"      </NamedPage>"
    @"      <NamedPage name='test2'>"
    @"          <foo>2</foo>"
    @"      </NamedPage>"
    @"  </tome>"
    @"</TomePage>";

@implementation TomePage {
@protected
    MTMutableTomeProp* _tome;
}

+ (NSString*)XML { return XML_STRING; }

- (id<MTTome>)tome { return _tome.value; }

- (id)init {
    if ((self = [super init])) {
        _tome = [[MTMutableTomeProp alloc] initWithName:@"tome" nullable:NO pageType:[NamedPage class]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_tome);
}

@end
