//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@interface TomePage : MTMutablePage

+ (NSString*)XML;

@property (nonatomic,readonly) id<MTTome> tome;

@end
