//
// microtome - Copyright 2012 Three Rings Design


@protocol MTPage;
@class MTLibrary;

@protocol MTProp <NSObject>
@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) id<MTPage> parent;
- (void)resolveRefs:(MTLibrary*)ctx;
@end

@protocol MTObjectProp <MTProp>
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,readonly) id value;
@end

@protocol MTMutableObjectProp <MTObjectProp>
@property (nonatomic,strong) id value;
@end