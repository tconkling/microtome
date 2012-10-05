//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@implementation MTPropBase

@synthesize name = _name;
@synthesize parent = _parent;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent {
    if ((self = [super init])) {
        _name = name;
        _parent = parent;
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

@synthesize value = _value;
@synthesize nullable = _nullable;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent type:(__unsafe_unretained Class)type nullable:(BOOL)nullable {
    if ((self = [super initWithName:name parent:parent])) {
        _type = type;
        _nullable = nullable;
    }
    return self;
}

- (void)setValue:(id)value {
    [self validateValue:value];
    _value = value;
}

- (void)validateValue:(id)val {
    if (val != nil && ![val isKindOfClass:_type]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible value type [required=%@, got=%@]", _type, [val class]];
    }
}

@end