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
    id<MTProp> prop = MTGetProp(self, name);
    return ([prop conformsToProtocol:@protocol(MTObjectProp)] ? ((id<MTObjectProp>)prop).value : nil);
}

@end

@implementation MTMutableNamedPage
@end