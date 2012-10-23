//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

@protocol MTPage;
@class MTLoadTask;

@interface MTLibrary (MTInternal)

@property (nonatomic,strong) id<MTPrimitiveValueHandler> primitiveValueHandler;

- (void)beginLoad:(MTLoadTask*)task;
- (void)finalizeLoad:(MTLoadTask*)task;
- (void)abortLoad:(MTLoadTask*)task;

- (id<MTObjectValueHandler>)requireValueHandlerForClass:(Class)requiredClass;

- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName;
- (id<MTPage>)requirePage:(NSString*)fullyQualifiedName pageClass:(Class)pageClass;

@end
