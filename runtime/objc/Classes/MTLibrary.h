//
// microtome - Copyright 2012 Three Rings Design

#import "MTContainer.h"

@protocol MTValueHandler;
@protocol MTPage;

@interface MTLibrary : NSObject <MTContainer> {
@protected
    NSMutableDictionary* _pages;
    NSMutableDictionary* _pageClasses;
    NSMutableDictionary* _valueHandlers;
}

/// Removes all pages from the library
- (void)removeAllPages;

- (void)registerPageClasses:(NSArray*)classes;
- (void)registerValueHandler:(id<MTValueHandler>)handler;

/// FooPage* page = library[@"myFooPage"]
- (id)objectForKeyedSubscript:(id)key;

// protected
- (void)addPages:(NSArray*)pages;

- (id<MTValueHandler>)requireValueHandlerForClass:(Class)requiredClass;

- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName;
- (id<MTPage>)requirePage:(NSString*)fullyQualifiedName pageClass:(Class)pageClass;

@end
