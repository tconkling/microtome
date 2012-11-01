//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageRef.h"

@interface MTMutablePageRef : NSObject <MTPageRef> {
@protected
    Class _pageClass;
    NSString* _pageName;
    __weak id _page;
}

@property (nonatomic,weak) id page;

- (id)initWithPageClass:(Class)pageClass pageName:(NSString*)pageName;

@end