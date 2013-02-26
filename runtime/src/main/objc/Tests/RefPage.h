
#import "MTPage.h"

@class PrimitivePage;

@interface RefPage : MTPage

@property (nonatomic,readonly) PrimitivePage* nested;

@end
