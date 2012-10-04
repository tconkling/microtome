//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@implementation MTPropBase

@synthesize name = _name;

- (id)initWithName:(NSString*)name {
    if ((self = [super init])) {
        _name = name;
    }
    return self;
}

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

@implementation MTObjectPropBase

@synthesize nullable = _nullable;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable {
    if ((self = [super initWithName:name])) {
        _nullable = nullable;
    }
    return self;
}

@end