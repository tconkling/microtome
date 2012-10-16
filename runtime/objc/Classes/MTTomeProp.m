//
// microtome - Copyright 2012 Three Rings Design

#import "MTTomeProp.h"

#import "MTTome.h"
#import "MTUtils.h"

@implementation MTTomeProp

- (Class)valueType {
    return [MTMutableTome class];
}

- (void)validate {
    [super validate];
    MTMutableTome* tome = (MTMutableTome*)_value;
    if (tome != nil && ![tome.pageType isSubclassOfClass:_subType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible tome (pageType '%@' is not a subclass of '%@')",
         tome.pageType, _subType];
    }
}

- (void)resolveRefs:(MTLibrary*)library {
    MTMutableTome* tome = (MTMutableTome*)_value;
    if (tome != nil) {
        MTResolveTomeRefs(tome, library);
    }
}

@end
