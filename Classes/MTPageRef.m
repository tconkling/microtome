//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageRef.h"

@implementation MTMutablePageRef

@synthesize pageType = _pageType;
@synthesize page = _page;

- (id)initWithPageType:(Class)pageType pageName:(NSString*)pageName {
    if ((self = [super init])) {
        _pageType = pageType;
        _pageName = pageName;
    }
    return self;
}

@end