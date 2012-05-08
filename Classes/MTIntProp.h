//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@interface MTIntProp : MTPropBase {
@protected
    int _min;
    int _max;
    int _default;
}

- (id)initWithName:(NSString*)name
        hasDefault:(BOOL)hasDefault
        defaultVal:(int)defaultVal
               min:(int)min
               max:(int)max;

@end
