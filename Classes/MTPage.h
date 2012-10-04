//
// microtome - Copyright 2012 Three Rings Design

@class MTMutableStringProp;

@protocol MTPage <NSObject>
@property (nonatomic,readonly) NSArray* props;
@end

@protocol MTNamedPage <MTPage>
@property (nonatomic,readonly) NSString* name;
@end

@interface MTMutablePage : NSObject <MTPage>
@end

@interface MTMutableNamedPage : MTMutablePage <MTNamedPage>
@property (nonatomic,strong) NSString* name;
@end

#define MT_PROPS(...) ({ [super.props arrayByAddingObjectsFromArray:@[ __VA_ARGS__ ]]; })

