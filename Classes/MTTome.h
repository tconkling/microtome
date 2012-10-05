//
// microtome - Copyright 2012 Three Rings Design

#import "MTContainer.h"

@protocol MTNamedPage;

@protocol MTTome <NSObject,MTContainer>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) int count;

- (id<MTNamedPage>)pageNamed:(NSString*)name;
- (id<MTNamedPage>)requirePageNamed:(NSString*)name;
@end

@interface MTMutableTome : NSObject <MTTome> {
@protected
    Class _pageType;
    NSMutableDictionary* _pages;
}

- (id)initWithPageType:(Class)pageType;

- (void)addPage:(id<MTNamedPage>)page;

@end

