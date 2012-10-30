//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

@protocol MTDataElement;
@protocol MTPage;
@class MTLoadTask;
@class MTMutableTome;
@class MTMutablePage;

@interface MTLibrary (MTInternal)

- (void)addLoadedItems:(MTLoadTask*)task;
- (void)finalizeLoadedItems:(MTLoadTask*)task;
- (void)abortLoad:(MTLoadTask*)task;

- (id<MTObjectMarshaller>)requireMarshallerForClass:(Class)requiredClass;

- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)pageWithQualifiedName:(NSString*)qualifiedName;
- (id<MTPage>)requirePageWithQualifiedName:(NSString*)qualifiedName pageClass:(Class)pageClass;

- (MTMutableTome*)loadTome:(id<MTDataElement>)data pageClass:(__unsafe_unretained Class)pageClass;
- (MTMutablePage*)loadPage:(id<MTDataElement>)data superclass:(Class)superclass;

@end
