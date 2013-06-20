
#import "PrimitiveListPage.h"
#import "microtome.h"

static MTPropSpec* s_stringsSpec = nil;
static MTPropSpec* s_booleansSpec = nil;
static MTPropSpec* s_intsSpec = nil;
static MTPropSpec* s_floatsSpec = nil;

@implementation PrimitiveListPage {
@protected
    MTObjectProp* _strings;
    MTObjectProp* _booleans;
    MTObjectProp* _ints;
    MTObjectProp* _floats;
}

- (NSArray*)strings { return _strings.value; }
- (NSArray*)booleans { return _booleans.value; }
- (NSArray*)ints { return _ints.value; }
- (NSArray*)floats { return _floats.value; }

- (NSArray*)props { return MT_PROPS(_strings, _booleans, _ints, _floats, ); }

- (id)init {
    if ((self = [super init])) {
        _strings = [[MTObjectProp alloc] initWithPropSpec:s_stringsSpec];
        _booleans = [[MTObjectProp alloc] initWithPropSpec:s_booleansSpec];
        _ints = [[MTObjectProp alloc] initWithPropSpec:s_intsSpec];
        _floats = [[MTObjectProp alloc] initWithPropSpec:s_floatsSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [PrimitiveListPage class]) {
        s_stringsSpec = [[MTPropSpec alloc] initWithName:@"strings"
            annotations:nil
            valueClasses:@[ [NSArray class],[NSString class], ] ];
        s_booleansSpec = [[MTPropSpec alloc] initWithName:@"booleans"
            annotations:nil
            valueClasses:@[ [NSArray class],[BOOL class], ] ];
        s_intsSpec = [[MTPropSpec alloc] initWithName:@"ints"
            annotations:nil
            valueClasses:@[ [NSArray class],[int class], ] ];
        s_floatsSpec = [[MTPropSpec alloc] initWithName:@"floats"
            annotations:nil
            valueClasses:@[ [NSArray class],[float class], ] ];
    }
}

@end
