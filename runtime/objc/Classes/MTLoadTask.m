//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoadTask.h"

@implementation MTLoadTask

@synthesize libraryItems = _libraryItems;
@synthesize state = _state;

- (id)init {
    if ((self = [super init])) {
        _libraryItems = [[NSMutableArray alloc] init];
        _state = MT_Loading;
    }
    return self;
}

- (void)addItem:(id<MTLibraryItem>)item {
    NSAssert(_state == MT_Loading, @"state != MT_Loading");
    [_libraryItems addObject:item];
}

@end
