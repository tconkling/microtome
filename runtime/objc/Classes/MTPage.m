//
// microtome - Copyright 2012 Three Rings Design

#import "MTPage.h"

#import "MTProp.h"
#import "MTUtils.h"

@implementation MTMutablePage

- (NSArray*)props {
    return @[];
}

// MTContainer
- (id)childNamed:(NSString*)name {
    MTProp* prop = MTGetProp(self, name);
    return ([prop isKindOfClass:[MTObjectProp class]] ? ((MTObjectProp*)prop).value : nil);
}

@end