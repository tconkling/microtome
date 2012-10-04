//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageRefProp.h"

@implementation MTMutablePageRefProp

@synthesize pageType = _pageType;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType {
    if ((self = [super initWithName:name nullable:nullable])) {
        _pageType = pageType;
    }
    return self;
}

- (void)setValue:(id)value {
    [self validateValue:value isType:[MTMutablePageRef class]];
    MTMutablePageRef* ref = (MTMutablePageRef*)value;
    if (ref != nil && ![ref.pageType isSubclassOfClass:_pageType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible pageRef (pageType '%@' is not a subclass of '%@')",
                    ref.pageType, _pageType];
    }

    _value = value;
}

@end
