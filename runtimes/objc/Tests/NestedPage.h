
#import "MTPage.h"

@class PrimitivePage;

@interface NestedPage : MTPage

@property (nonatomic,readonly) PrimitivePage* nested;

@end
