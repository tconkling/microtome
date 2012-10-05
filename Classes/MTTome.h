//
// microtome - Copyright 2012 Three Rings Design

#import "MTContainer.h"

@protocol MTPage;

@protocol MTTome <NSObject,MTContainer>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) int pageCount;
@property (nonatomic,readonly) id<NSFastEnumeration> pages;

- (id<MTPage>)pageNamed:(NSString*)name;
- (id<MTPage>)requirePageNamed:(NSString*)name;
@end

@interface MTMutableTome : NSObject <MTTome> {
@protected
    Class _pageType;
    NSMutableDictionary* _pages;
}

- (id)initWithPageType:(Class)pageType;

- (void)addPage:(id<MTPage>)page;

@end

