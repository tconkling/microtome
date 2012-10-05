//
// microtome - Copyright 2012 Three Rings Design

#import "RefPage.h"
#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<refTest type='RefPage'>"
    @"  <nested>tomeTest.tome.test1</nested>"
    @"</refTest>";

@implementation RefPage {
@protected
    MTMutablePageRefProp* _nested;
}

+ (NSString*)XML { return XML_STRING; }

- (MTMutablePageRef*)nestedRef { return _nested.value; }
- (PrimitivePage*)nested { return self.nestedRef.page; }

- (id)init {
    if ((self = [super init])) {
        _nested = [[MTMutablePageRefProp alloc] initWithName:@"nested" parent:self nullable:NO pageType:[PrimitivePage class]];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_nested);
}

@end
