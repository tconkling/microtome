//
// microtome - Copyright 2012 Three Rings Design

#import "MTPage.h"
#import "MTPage+Internal.h"

#import "MTTypeInfo.h"
#import "MTProp.h"
#import "MTUtils.h"

@implementation MTPage

@synthesize name = _name;

- (void)setName:(NSString*)name {
    _name = name;
}

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