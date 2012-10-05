//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@protocol MTStringProp <MTObjectProp>
@end

@interface MTMutableStringProp : MTObjectPropBase <MTStringProp>
- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable;
@end

