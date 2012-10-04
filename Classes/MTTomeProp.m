//
// microtome - Copyright 2012 Three Rings Design

#import "MTTomeProp.h"

#import "MTTome.h"

@implementation MTMutableTomeProp

@synthesize pageType = _pageType;
@synthesize value = _tome;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType {
    if ((self = [super initWithName:name nullable:nullable])) {
        _pageType = pageType;
    }
    return self;
}

- (void)setValue:(MTMutableTome*)value {
    if (value != nil && value.pageType != _pageType) {
        [NSException raise:NSGenericException
            format:@"MutableTome has the wrong page type [required=%@, got=%@]",
            _pageType, value.pageType];
    }
    _tome = value;
}

@end
