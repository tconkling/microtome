//
// microtome - Copyright 2012 Three Rings Design


@protocol MTPage;
@class MTLibrary;

@protocol MTProp <NSObject>
@property (nonatomic,readonly) NSString* name;
- (void)resolveRefs:(MTLibrary*)library;
@end

@protocol MTObjectProp <MTProp>
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,strong) id value;
@end

@protocol MTParameterizedObjectProp <MTObjectProp>
@property (nonatomic,readonly) Class subType;
@end