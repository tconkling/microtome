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
