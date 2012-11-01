//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@class PrimitivePage;

@interface NestedPage : MTMutablePage

@property (nonatomic,readonly) PrimitivePage* nested;

@end