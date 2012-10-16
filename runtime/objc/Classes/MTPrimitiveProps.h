//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@interface MTBoolProp : MTPropBase
@property (nonatomic,assign) BOOL value;
@end

@interface MTIntProp : MTPropBase
@property (nonatomic,assign) int value;
@end

@interface MTFloatProp : MTPropBase
@property (nonatomic,assign) float value;
@end