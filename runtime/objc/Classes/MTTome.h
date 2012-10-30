//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibraryItem.h"

@protocol MTPage;
@class MTTypeInfo;

@protocol MTTome <NSObject,MTLibraryItem>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) int pageCount;
@property (nonatomic,readonly) id<NSFastEnumeration> pages;

- (id<MTPage>)pageNamed:(NSString*)name;
- (id<MTPage>)requirePageNamed:(NSString*)name;
@end