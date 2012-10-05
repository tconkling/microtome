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

@interface MTObjectPropBase : MTPropBase <MTMutableObjectProp> {
@protected
    Class _type;
    BOOL _nullable;
    id _value;
}
- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent type:(Class)type nullable:(BOOL)nullable;

// protected
- (void)validateValue:(id)val;

@end
