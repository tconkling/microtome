//
// microtome - Copyright 2012 Three Rings Design

#import "MTTomeProp.h"

#import "MTTome.h"

@implementation MTMutableTomeProp

@synthesize pageType = _pageType;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType {
    if ((self = [super initWithName:name type:[MTMutableTome class] nullable:nullable])) {
        _pageType = pageType;
    }
    return self;
}

- (void)validateValue:(id)val {
    [super validateValue:val];
    MTMutableTome* tome = (MTMutableTome*)val;
    if (tome != nil && ![tome.pageType isSubclassOfClass:_pageType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible tome (pageType '%@' is not a subclass of '%@')",
         tome.pageType, _pageType];
    }
}

@end
