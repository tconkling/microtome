//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageRefProp.h"

@implementation MTMutablePageRefProp

@synthesize pageType = _pageType;
@synthesize value = _ref;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType {
    if ((self = [super initWithName:name nullable:nullable])) {
        _pageType = pageType;
    }
    return self;
}

- (void)setValue:(MTMutablePageRef*)value {
    if (value != nil && ![value.pageType isSubclassOfClass:_pageType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible pageRef (pageType '%@' is not a subclass of '%@')",
                    value.pageType, _pageType];
    }
    _ref = value;
}

@end
