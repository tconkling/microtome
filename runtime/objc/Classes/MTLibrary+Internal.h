//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

@protocol MTPage;
@class MTLoadTask;
@class MTMutableTome;
@class MTMutablePage;

@interface MTLibrary (MTInternal)

- (void)beginLoad:(MTLoadTask*)task;
- (void)finalizeLoad:(MTLoadTask*)task;
- (void)abortLoad:(MTLoadTask*)task;

- (id<MTObjectMarshaller>)requireMarshallerForClass:(Class)requiredClass;

- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)pageWithQualifiedName:(NSString*)qualifiedName;
- (id<MTPage>)requirePageWithQualifiedName:(NSString*)qualifiedName pageClass:(Class)pageClass;

- (MTMutableTome*)loadTome:(GDataXMLElement*)xml pageType:(__unsafe_unretained Class)pageType;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml superclass:(Class)superclass;

@end
