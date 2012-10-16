//
// microtome - Copyright 2012 Three Rings Design

#import "MTType.h"

@implementation MTType

@synthesize clazz = _clazz;
@synthesize subtype = _subtype;

- (id)initWithClass:(Class)clazz subtype:(MTType*)subtype {
    if ((self = [super init])) {
        _clazz = clazz;
        _subtype = subtype;
    }
    return self;
}

@end

MTType* MTBuildType (NSArray* classes) {
    MTType* last = nil;
    for (Class clazz in classes.reverseObjectEnumerator) {
        last = [[MTType alloc] initWithClass:clazz subtype:last];
    }
    return last;
}
