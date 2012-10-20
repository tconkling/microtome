//
// microtome - Copyright 2012 Three Rings Design

#import "NestedPage.h"
#import "PrimitivePage.h"

static NSString* const XML_STRING =
    @"<root><nestedTest type='NestedPage'>"
    @"  <nested type='PrimitivePage' foo='true' bar='2' baz='3.1415'/>"
    @"</nestedTest></root>";

static MTPropSpec* _nestedSpec = nil;

@implementation NestedPage {
@protected
    MTObjectProp* _nested;
}

+ (NSString*)XML { return XML_STRING; }

- (PrimitivePage*)nested { return _nested.value; }

- (id)init {
    if ((self = [super init])) {
        _nested = [[MTObjectProp alloc] initWithPropSpec:_nestedSpec];
    }
    return self;
}

- (NSArray*)props {
    return MT_PROPS(_nested);
}

+ (void)initialize {
    if (self == [NestedPage class]) {
        _nestedSpec = [[MTPropSpec alloc] initWithName:@"nested" annotations:nil valueTypes:@[[PrimitivePage class]]];
    }
}

@end
