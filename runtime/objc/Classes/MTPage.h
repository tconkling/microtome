//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibraryItem.h"

@protocol MTPage <NSObject,MTLibraryItem>
@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) NSArray* props;
@end

@interface MTMutablePage : NSObject <MTPage>
@property (nonatomic,strong) NSString* name;
@end

#define MT_PROPS(...) ({ [super.props arrayByAddingObjectsFromArray:@[ __VA_ARGS__ ]]; })

