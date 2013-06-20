
#import "MTPage.h"


@interface PrimitiveListPage : MTPage

@property (nonatomic,readonly) NSArray* strings;
@property (nonatomic,readonly) NSArray* booleans;
@property (nonatomic,readonly) NSArray* ints;
@property (nonatomic,readonly) NSArray* floats;

@end
