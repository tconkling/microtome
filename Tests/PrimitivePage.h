//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@interface PrimitivePage : NSObject <MTPage>

+ (NSString*) XML;

@property (nonatomic,readonly) BOOL foo;
@property (nonatomic,readonly) int bar;
@property (nonatomic,readonly) float baz;

@end
