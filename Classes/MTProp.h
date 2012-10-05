//
// microtome - Copyright 2012 Three Rings Design

#import "MTNamed.h"

@protocol MTPage;
@class MTLibrary;

@protocol MTProp <NSObject,MTNamed>
@property (nonatomic,readonly) id<MTPage> parent;
- (void)resolveRefs:(MTLibrary*)ctx;
@end

@protocol MTObjectProp <MTProp>
@property (nonatomic,readonly) BOOL nullable;
@property (nonatomic,readonly) id value;
@end

@protocol MTMutableProp <MTProp>
@end

@protocol MTMutableObjectProp <MTObjectProp,MTMutableProp>
@property (nonatomic,strong) id value;
@end