
#import "ListPage.h"
#import "PrimitivePage.h"
#import "microtome.h"

static MTPropSpec* s_kidsSpec = nil;

@implementation ListPage {
@protected
    MTObjectProp* _kids;
}

- (NSArray*)kids { return _kids.value; }

- (NSArray*)props { return MT_PROPS(_kids, ); }

- (id)init {
    if ((self = [super init])) {
        _kids = [[MTObjectProp alloc] initWithPropSpec:s_kidsSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [ListPage class]) {
        s_kidsSpec = [[MTPropSpec alloc] initWithName:@"kids"
            annotations:nil
            valueClasses:@[ [NSArray class],[PrimitivePage class], ] ];
    }
}

@end
