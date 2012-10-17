//
// microtome - Copyright 2012 Three Rings Design

#import "MTContainer.h"

@protocol MTValueHandler;
@protocol MTLoader;
@protocol MTPage;

@interface MTLibrary : NSObject <MTContainer> {
@protected
    id<MTLoader> _loader;
    NSMutableDictionary* _loadedPages;
    NSMutableDictionary* _pageClasses;
    NSMutableDictionary* _valueHandlers;
}

- (id)initWithLoader:(id<MTLoader>)loader;

- (id)loadData:(id)data;
- (void)unloadDataWithName:(NSString*)name;

- (void)registerPageClasses:(NSArray*)classes;
- (void)registerValueHandler:(id<MTValueHandler>)handler;

- (id<MTValueHandler>)requireValueHandlerForClass:(Class)requiredClass;

// protected
- (Class)pageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name;
- (Class)requirePageClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName;
- (id<MTPage>)requirePage:(NSString*)fullyQualifiedName pageClass:(Class)pageClass;

@end
