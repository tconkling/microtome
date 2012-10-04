//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"

@interface MTPropBase : NSObject <MTMutableProp> {
@protected
    NSString* _name;
    NSMutableDictionary* _annotations;
}

- (id)initWithName:(NSString*)name;
- (id)getAnnotation:(Class)annotationClass;

@end

@interface MTObjectPropBase : MTPropBase <MTMutableObjectProp> {
@protected
    BOOL _nullable;
}
- (id)initWithName:(NSString*)name nullable:(BOOL)nullable;
@end
