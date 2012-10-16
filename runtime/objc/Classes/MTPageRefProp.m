//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageRefProp.h"

#import "MTPageRef.h"
#import "MTLibrary.h"

@implementation MTPageRefProp

- (Class)valueType {
    return [MTMutablePageRef class];
}

- (void)validate {
    [super validate];
    
    MTMutablePageRef* ref = (MTMutablePageRef*)_value;
    if (ref != nil && ![ref.pageType isSubclassOfClass:_subType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible pageRef (pageType '%@' is not a subclass of '%@')",
         ref.pageType, _subType];
    }
}

- (void)resolveRefs:(MTLibrary*)library {
    if (_value != nil) {
        MTMutablePageRef* ref = (MTMutablePageRef*)_value;
        ref.page = [library getPage:ref.pageName];
        if (ref.page == nil) {
            [NSException raise:NSGenericException
                format:@"Could not resolve PageRef [name=%@, pageName=%@]", self.name, ref.pageName];
        }
    }
}

@end
