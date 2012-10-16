//
// microtome - Copyright 2012 Three Rings Design

@interface MTType : NSObject {
@protected
    Class _clazz;
    MTType* _subtype;
}

@property (nonatomic,readonly) Class clazz;
@property (nonatomic,readonly) MTType* subtype;
- (id)initWithClass:(Class)clazz subtype:(MTType*)subtype;
@end

MTType* MTBuildType (NSArray* classes);
