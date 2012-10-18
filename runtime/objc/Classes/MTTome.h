//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibraryItem.h"

@protocol MTPage;
@class MTType;

@protocol MTTome <NSObject,MTLibraryItem>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) int pageCount;
@property (nonatomic,readonly) id<NSFastEnumeration> pages;

- (id<MTPage>)pageNamed:(NSString*)name;
- (id<MTPage>)requirePageNamed:(NSString*)name;
@end

@interface MTMutableTome : NSObject <MTTome> {
@protected
    NSString* _name;
    MTType* _type;
    NSMutableDictionary* _pages;
}

- (id)initWithName:(NSString*)name pageType:(Class)pageType;

- (void)addPage:(id<MTPage>)page;

@end

