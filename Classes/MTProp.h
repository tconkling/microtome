//
// microtome - Copyright 2012 Three Rings Design

@protocol MTProp <NSObject>
@property (nonatomic,readonly) NSString* name;
- (id)getAnnotation:(Class)annotationClass;
@end

@protocol MTObjectProp <MTProp>
@property (nonatomic,readonly) BOOL nullable;
@end

@protocol MTMutableProp <MTProp>
@property (nonatomic,strong) NSString* name;
- (void)addAnnotation:(id)annotation;
@end

@protocol MTMutableObjectProp <MTObjectProp,MTMutableProp>
@property (nonatomic,assign) BOOL nullable;
@end

@protocol MTContainerProp <MTObjectProp>
@property (nonatomic,readonly) NSArray* children;
@end

@protocol MTMutableContainerProp <MTContainerProp,MTMutableProp>
@end

