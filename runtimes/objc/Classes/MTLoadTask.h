//
// microtome - Copyright 2012 Three Rings Design

@class MTLibrary;
@protocol MTLibraryItem;

typedef enum {
    MT_Loading,
    MT_AddedItems,
    MT_Finalized,
    MT_Aborted
} MTLoadState;

@interface MTLoadTask : NSObject {
@protected
    NSMutableArray* _libraryItems;
    NSMutableArray* _pendingTemplatedPages;
    MTLoadState _state;
}

@property (nonatomic,readonly) NSArray* libraryItems;
@property (nonatomic,readonly) NSMutableArray* pendingTemplatedPages;
@property (nonatomic,assign) MTLoadState state;

- (void)addItem:(id<MTLibraryItem>)item;

@end
