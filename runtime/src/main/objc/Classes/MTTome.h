//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibraryItem.h"

@class MTPage;
@class MTTypeInfo;

@protocol MTTome <NSObject,MTLibraryItem>
@property (nonatomic,readonly) Class pageClass;
@property (nonatomic,readonly) int pageCount;
@property (nonatomic,readonly) id<NSFastEnumeration> pages;

- (MTPage*)pageNamed:(NSString*)name;
- (MTPage*)requirePageNamed:(NSString*)name;
@end