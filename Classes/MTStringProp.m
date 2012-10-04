//
// microtome - Copyright 2012 Three Rings Design

#import "MTStringProp.h"

@implementation MTMutableStringProp

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable {
    return [super initWithName:name type:[NSString class] nullable:nullable];
}

@end
