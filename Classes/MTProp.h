//
// microtome - Copyright 2012 Three Rings Design

@protocol MTProp <NSObject>
@property (nonatomic,readonly) NSString* name;
- (id)getAnnotation:(Class)annotationClass;
@end

@protocol MTObjectProp <MTProp>
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,readonly) id value;
@end

@protocol MTMutableProp <MTProp>
- (void)addAnnotation:(id)annotation;
@end

@protocol MTMutableObjectProp <MTObjectProp,MTMutableProp>
@property (nonatomic,strong) id value;
@end

@protocol MTContainerProp <MTObjectProp>
@property (nonatomic,readonly) NSArray* children;
@end

@protocol MTMutableContainerProp <MTContainerProp,MTMutableProp>
@end

