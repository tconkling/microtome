//
// microtome - Copyright 2012 Three Rings Design

#import "MTMutablePage.h"

#import "MTType.h"
#import "MTProp.h"
#import "MTUtils.h"

@implementation MTMutablePage

- (MTType*)type {
    return [[MTType alloc] initWithClass:[self class] subtype:nil];
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