//
// microtome - Copyright 2012 Three Rings Design

#import "RefPage.h"
#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<test type='RefPage'>"
    @"  <nested>tome.test1</nested>"
    @"</test>";

@implementation RefPage {
@protected
    MTMutablePageRefProp* _nested;
}

+ (NSString*)XML { return XML_STRING; }

- (MTMutablePageRef*)nestedRef { return _nested.value; }
- (PrimitivePage*)nested { return self.nestedRef.page; }

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_nested);
}

@end
