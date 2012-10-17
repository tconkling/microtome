//
// microtome - Copyright 2012 Three Rings Design

@class MTType;
@class MTLibrary;

@interface MTPropSpec : NSObject {
@protected
    NSString* _name;
}
@property (nonatomic,readonly) NSString* name;
- (id)initWithName:(NSString*)name;
@end

@interface MTObjectPropSpec : MTPropSpec {
@protected
    BOOL _nullable;
    MTType* _valueType;
}
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,readonly) MTType* valueType;
- (id)initWithName:(NSString*)name nullable:(BOOL)nullable valueType:(MTType*)valueType;
@end

@interface MTProp : NSObject {
@protected
    MTPropSpec* _spec;
}
@property (nonatomic,readonly) NSString* name;
- (id)initWithPropSpec:(MTPropSpec*)spec;
@end

@interface MTObjectProp : MTProp {
@protected
    id _value;
}
@property (nonatomic,readonly) MTType* valueType;
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,strong) id value;
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