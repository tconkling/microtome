//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@protocol MTIntProp <MTProp>
@property (nonatomic,readonly) int value;
@end

@interface MTMutableIntProp : MTPropBase {
@protected
    int _value;
}
@property (nonatomic,assign) int value;
@end