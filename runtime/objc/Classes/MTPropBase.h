//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"

@interface MTPropBase : NSObject <MTProp> {
@protected
    __weak id<MTPage> _parent;
    NSString* _name;
}

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent;

@end

@interface MTObjectPropBase : MTPropBase <MTObjectProp> {
@protected
    BOOL _nullable;
    id _value;
}
- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable;

// protected
- (Class)valueType;
- (void)validate;

@end

@interface MTParameterizedObjectPropBase : MTObjectPropBase <MTParameterizedObjectProp> {
@protected
    Class _subType;
}

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable subType:(Class)subType;

@end
