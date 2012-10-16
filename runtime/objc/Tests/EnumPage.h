//
// microtome - Copyright 2012 Three Rings Design

#import "microtome.h"

@class TestEnum;

@interface EnumPage : MTMutablePage

+ (NSString*)XML;

@property (nonatomic,readonly) TestEnum* foo;

@end
