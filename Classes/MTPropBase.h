//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"

@interface MTPropBase : NSObject <MTMutableProp> {
@protected
    NSString* _name;
    BOOL _hasDefault;
    NSMutableDictionary* _annotations;
}

- (id)getAnnotation:(Class)annotationClass;
- (void)addAnnotation:(id)annotation;

@end
