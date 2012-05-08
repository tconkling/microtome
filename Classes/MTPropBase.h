//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"

@interface MTPropBase : NSObject <MTProp> {
@protected
    NSString* _name;
    BOOL _hasDefault;
}

- (id)initWithName:(NSString*)name hasDefault:(BOOL)hasDefault;

@end
