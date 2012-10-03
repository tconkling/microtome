//
// microtome - Copyright 2012 Three Rings Design

#import "MTTome.h"

@interface MTMutableTome : NSObject <MTTome> {
@protected
    Class _pageClass;
    NSMutableDictionary* _pages;
}

- (id)initWithPageClass:(Class)pageClass;

- (void)addPage:(id<MTNamedPage>)page;

@end

