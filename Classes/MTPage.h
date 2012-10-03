//
// microtome - Copyright 2012 Three Rings Design

@protocol MTProp;

@protocol MTPage <NSObject>
@property (nonatomic,readonly) NSArray* props;
@end

@protocol MTNamedPage <MTPage>
@property (nonatomic,readonly) NSString* name;
@end
