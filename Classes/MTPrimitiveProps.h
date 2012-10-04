//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@protocol MTBoolProp <MTProp>
@property (nonatomic,readonly) BOOL value;
@end

@protocol MTIntProp <MTProp>
@property (nonatomic,readonly) int value;
@end

@protocol MTFloatProp <MTProp>
@property (nonatomic,readonly) float value;
@end

@interface MTMutableBoolProp : MTPropBase <MTBoolProp>
@property (nonatomic,assign) BOOL value;
@end

@interface MTMutableIntProp : MTPropBase <MTIntProp>
@property (nonatomic,assign) int value;
@end

@interface MTMutableFloatProp : MTPropBase <MTFloatProp>
@property (nonatomic,assign) float value;
@end