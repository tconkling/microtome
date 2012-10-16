//
// microtome - Copyright 2012 Three Rings Design

@class MTType;
@class MTLibrary;

@interface MTProp : NSObject {
@protected
    NSString* _name;
}

@property (nonatomic,readonly) NSString* name;

- (id)initWithName:(NSString*)name;

@end

@interface MTObjectProp : MTProp {
@protected
    BOOL _nullable;
    MTType* _valueType;
    id _value;
}

@property (nonatomic,readonly) MTType* valueType;
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,strong) id value;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable valueType:(MTType*)valueType;

// protected
- (void)validate;

@end

// primitive props
@interface MTBoolProp : MTProp
@property (nonatomic,assign) BOOL value;
@end

@interface MTIntProp : MTProp
@property (nonatomic,assign) int value;
@end

@interface MTFloatProp : MTProp
@property (nonatomic,assign) float value;
@end