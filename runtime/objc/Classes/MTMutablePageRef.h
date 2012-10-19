//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageRef.h"

@interface MTMutablePageRef : NSObject <MTPageRef> {
@protected
    Class _pageType;
    NSString* _pageName;
    __weak id _page;
}

@property (nonatomic,weak) id page;

- (id)initWithPageType:(Class)pageType pageName:(NSString*)pageName;

@end