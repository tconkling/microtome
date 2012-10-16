//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageProp.h"

#import "MTPage.h"
#import "MTUtils.h"

@implementation MTPageProp

- (Class)valueType {
    return _subType;
}

- (void)resolveRefs:(MTLibrary*)library {
    MTMutablePage* page = (MTMutablePage*)_value;
    if (page != nil) {
        MTResolvePageRefs(page, library);
    }
}

@end
