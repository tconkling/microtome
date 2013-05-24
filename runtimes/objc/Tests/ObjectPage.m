
#import "ObjectPage.h"
#import "microtome.h"

static MTPropSpec* s_fooSpec = nil;

@implementation ObjectPage {
@protected
    MTObjectProp* _foo;
}

- (NSString*)foo { return _foo.value; }

- (NSArray*)props { return MT_PROPS(_foo, ); }

- (id)init {
    if ((self = [super init])) {
        _foo = [[MTObjectProp alloc] initWithPropSpec:s_fooSpec];
    }
    return self;
}

+ (void)initialize {
    if (self == [ObjectPage class]) {
        s_fooSpec = [[MTPropSpec alloc] initWithName:@"foo"
            annotations:nil
            valueClasses:@[ [NSString class], ] ];
    }
}

@end
