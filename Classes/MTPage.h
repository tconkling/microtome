//
// microtome - Copyright 2012 Three Rings Design

#import "MTNamed.h"
#import "MTContainer.h"

@class MTMutableStringProp;

@protocol MTPage <NSObject,MTContainer>
@property (nonatomic,readonly) NSArray* props;
@end

@protocol MTNamedPage <MTPage,MTNamed>
@end

@interface MTMutablePage : NSObject <MTPage>
@end

@interface MTMutableNamedPage : MTMutablePage <MTNamedPage>
@property (nonatomic,strong) NSString* name;
@end

#define MT_PROPS(...) ({ [super.props arrayByAddingObjectsFromArray:@[ __VA_ARGS__ ]]; })

