//
// microtome - Copyright 2012 Three Rings Design

#import "MTMutablePage.h"

#import "MTTypeInfo.h"
#import "MTProp.h"
#import "MTUtils.h"

@implementation MTMutablePage

@synthesize name = _name;

- (MTTypeInfo*)type {
    return [[MTTypeInfo alloc] initWithClass:[self class] subtype:nil];
}

- (NSArray*)props {
    return @[];
}

// MTContainer
- (id)childNamed:(NSString*)name {
    MTProp* prop = MTGetProp(self, name);
    return ([prop isKindOfClass:[MTObjectProp class]] ? ((MTObjectProp*)prop).value : nil);
}

@end