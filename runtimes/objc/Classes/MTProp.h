//
// microtome - Copyright 2012 Three Rings Design

@class MTTypeInfo;
@class MTLibrary;

@interface MTPropSpec : NSObject {
@protected
    NSString* _name;
    NSDictionary* _annotations;
    MTTypeInfo* _valueType;
}
@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) NSDictionary* annotations;
@property (nonatomic,readonly) MTTypeInfo* valueType;

- (id)initWithName:(NSString*)name annotations:(NSDictionary*)annotations valueClasses:(NSArray*)valueClasses;
@end

@interface MTProp : NSObject {
@protected
    MTPropSpec* _spec;
}
@property (nonatomic,readonly) NSString* name;

- (id)initWithPropSpec:(MTPropSpec*)spec;

- (BOOL)hasAnnotation:(NSString*)name;
- (BOOL)boolAnnotation:(NSString*)name default:(BOOL)defaultVal;
- (int)intAnnotation:(NSString*)name default:(int)defaultVal;
- (float)floatAnnotation:(NSString*)name default:(float)defaultVal;
- (NSString*)stringAnnotation:(NSString*)name default:(NSString*)defaultVal;
@end

@interface MTObjectProp : MTProp {
@protected
    id _value;
}
@property (nonatomic,readonly) MTTypeInfo* valueType;
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,strong) id value;
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