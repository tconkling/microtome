//
// microtome - Copyright 2012 Three Rings Design

#import "MTTypeInfo.h"

@implementation MTTypeInfo

@synthesize clazz = _clazz;
@synthesize subtype = _subtype;

- (id)initWithClass:(Class)clazz subtype:(MTTypeInfo*)subtype {
    if ((self = [super init])) {
        _clazz = clazz;
        _subtype = subtype;
    }
    return self;
}

@end

MTTypeInfo* MTBuildTypeInfo (NSArray* classes) {
    MTTypeInfo* last = nil;
    for (Class clazz in classes.reverseObjectEnumerator) {
        last = [[MTTypeInfo alloc] initWithClass:clazz subtype:last];
    }
    return last;
}
