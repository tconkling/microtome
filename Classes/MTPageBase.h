//
// microtome - Copyright 2012 Three Rings Design

#import "MTPage.h"

@interface MTPageBase : NSObject <MTPage> {
@protected
    NSArray* _props;
}

- (id)initWithProps:(NSArray*)props;
@end

@interface MTNamedPageBase : MTPageBase <MTNamedPage> {
@protected
    NSString* _name;
}

- (id)initWithName:(NSString*)name props:(NSArray*)props;
@end
