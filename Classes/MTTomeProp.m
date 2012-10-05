//
// microtome - Copyright 2012 Three Rings Design

#import "MTTomeProp.h"

#import "MTTome.h"
#import "MTUtils.h"

@implementation MTMutableTomeProp

@synthesize pageType = _pageType;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable pageType:(Class)pageType {
    if ((self = [super initWithName:name parent:parent type:[MTMutableTome class] nullable:nullable])) {
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

- (void)resolveRefs:(MTLibrary*)library {
    MTMutableTome* tome = (MTMutableTome*)_value;
    if (tome != nil) {
        MTResolveTomeRefs(tome, library);
    }
}

@end
