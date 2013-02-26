
#import "MTPage.h"

@class PrimitivePage;

@interface AnnotationPage : MTPage

@property (nonatomic,readonly) int foo;
@property (nonatomic,readonly) int bar;
@property (nonatomic,readonly) PrimitivePage* primitives;

@end
