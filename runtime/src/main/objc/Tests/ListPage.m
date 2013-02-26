
#import "ListPage.h"
#import "PrimitivePage.h"
#import "microtome.h"

static MTPropSpec* s_listSpec = nil;

@implementation ListPage {
@protected
    MTObjectProp* _list;
}

- (NSArray*)list { return _list.value; }

- (NSArray*)props { return MT_PROPS(_list, ); }

- (id)init {
    if ((self = [super init])) {
        _list = [[MTObjectProp alloc] initWithPropSpec:s_listSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [ListPage class]) {
        s_listSpec = [[MTPropSpec alloc] initWithName:@"list"
            annotations:nil
            valueClasses:@[ [NSArray class],[PrimitivePage class], ] ];
    }
}

@end
