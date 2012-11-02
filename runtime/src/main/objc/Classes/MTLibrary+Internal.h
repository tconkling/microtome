//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

@protocol MTDataElement;
@class MTPage;
@class MTLoadTask;
@class MTMutableTome;
@class MTPage;

@interface MTLibrary (MTInternal)

- (void)addLoadedItems:(MTLoadTask*)task;
- (void)finalizeLoadedItems:(MTLoadTask*)task;
- (void)abortLoad:(MTLoadTask*)task;

- (id<MTObjectMarshaller>)requireMarshallerForClass:(Class)requiredClass;

- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (MTPage*)pageWithQualifiedName:(NSString*)qualifiedName;
- (MTPage*)requirePageWithQualifiedName:(NSString*)qualifiedName pageClass:(Class)pageClass;

- (MTMutableTome*)loadTome:(id<MTDataElement>)data pageClass:(__unsafe_unretained Class)pageClass;
- (MTPage*)loadPage:(id<MTDataElement>)data superclass:(Class)superclass;

@end
