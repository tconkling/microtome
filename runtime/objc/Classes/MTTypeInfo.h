//
// microtome - Copyright 2012 Three Rings Design

@interface MTTypeInfo : NSObject {
@protected
    Class _clazz;
    MTTypeInfo* _subtype;
}

@property (nonatomic,readonly) Class clazz;
@property (nonatomic,readonly) MTTypeInfo* subtype;
- (id)initWithClass:(Class)clazz subtype:(MTTypeInfo*)subtype;
@end

MTTypeInfo* MTBuildTypeInfo (NSArray* classes);
