//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@implementation MTPropBase

@synthesize name = _name;

- (void)addAnnotation:(id)annotation {
    Class annotationClass = [annotation class];
    NSAssert([self getAnnotation:annotationClass] == nil,
             @"Annotation already exists [class=%@]", annotationClass);

    if (_annotations == nil) {
        _annotations = [[NSMutableDictionary alloc] init];
    }
    _annotations[(id<NSCopying>)annotationClass] = annotation;
}

- (id)getAnnotation:(Class)annotationClass {
    return _annotations[annotationClass];
}

@end
