//
// microtome - Copyright 2012 Three Rings Design

#import "MTMutablePageRef.h"

@implementation MTMutablePageRef

@synthesize pageClass = _pageClass;
@synthesize pageName = _pageName;
@synthesize page = _page;

- (id)initWithPageClass:(Class)pageClass pageName:(NSString*)pageName {
    if ((self = [super init])) {
        _pageClass = pageClass;
        _pageName = pageName;
    }
    return self;
}

@end
