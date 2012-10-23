//
// microtome - Copyright 2012 Three Rings Design

@protocol MTPrimitiveValueHandler;
@protocol MTValueHandler;
@protocol MTPrimitiveValueHandler;
@protocol MTPage;
@class MTLoadTask;

@interface MTLibrary : NSObject {
@protected
    NSMutableDictionary* _items;
    NSMutableDictionary* _pageClasses;
    NSMutableDictionary* _valueHandlers;
    id<MTPrimitiveValueHandler> _primitiveValueHandler;
}

@property (nonatomic,strong) id<MTPrimitiveValueHandler> primitiveValueHandler;

/// Removes all items from the library
- (void)removeAllItems;

- (void)registerPageClasses:(NSArray*)classes;
- (void)registerValueHandler:(id<MTValueHandler>)handler;

/// FooPage* page = library[@"myFooPage"] or
/// id<MTTome> tome = library[@"myTomeyTome"]
- (id)objectForKeyedSubscript:(id)key;

// protected
- (void)beginLoad:(MTLoadTask*)task;
- (void)finalizeLoad:(MTLoadTask*)task;
- (void)abortLoad:(MTLoadTask*)task;

- (id<MTValueHandler>)requireValueHandlerForClass:(Class)requiredClass;

- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName;
- (id<MTPage>)requirePage:(NSString*)fullyQualifiedName pageClass:(Class)pageClass;

@end
