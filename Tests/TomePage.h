//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@interface TomePage : NSObject <MTPage> {
@protected
    MTMutableTome* _tome;
}

+ (NSString*)XML;

@property (nonatomic,readonly) id<MTTome> tome;

@end
