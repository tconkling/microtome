//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@class PrimitivePage;

@interface RefPage : MTPage

@property (nonatomic,readonly) PrimitivePage* nested;

@end