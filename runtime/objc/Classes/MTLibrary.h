//
// microtome - Copyright 2012 Three Rings Design

@protocol MTObjectValueHandler;
@protocol MTPrimitiveValueHandler;

@interface MTLibrary : NSObject {
@protected
    NSMutableDictionary* _items;
    NSMutableDictionary* _pageClasses;
    NSMutableDictionary* _valueHandlers;
    id<MTPrimitiveValueHandler> _primitiveValueHandler;
}

/// Removes all items from the library
- (void)removeAllItems;

- (void)registerPageClasses:(NSArray*)classes;
- (void)registerValueHandler:(id<MTObjectValueHandler>)handler;

/// FooPage* page = library[@"myFooPage"] or
/// id<MTTome> tome = library[@"myTomeyTome"]
- (id)objectForKeyedSubscript:(id)key;

@end
