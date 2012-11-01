//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@class PrimitivePage;

@interface RefPage : MTMutablePage

@property (nonatomic,readonly) PrimitivePage* nested;

@end