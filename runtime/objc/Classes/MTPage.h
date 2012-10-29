//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibraryItem.h"

@protocol MTPage <NSObject,MTLibraryItem>
@property (nonatomic,readonly) NSArray* props;
@end

#define MT_PROPS(...) ({ [super.props arrayByAddingObjectsFromArray:@[ __VA_ARGS__ ]]; })

