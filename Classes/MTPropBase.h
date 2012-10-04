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
    Class _type;
    BOOL _nullable;
    id _value;
}
- (id)initWithName:(NSString*)name type:(Class)type nullable:(BOOL)nullable;

// protected
- (void)validateValue:(id)val;

@end
