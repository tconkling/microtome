//
// microtome - Copyright 2012 Three Rings Design

#import "MTStringProp.h"

@implementation MTMutableStringProp

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable {
    return [super initWithName:name parent:parent type:[NSString class] nullable:nullable];
}

@end
