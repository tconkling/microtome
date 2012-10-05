//
// microtome - Copyright 2012 Three Rings Design

#import "MTContainer.h"

@protocol MTLoader;
@protocol MTPage;

@interface MTLibrary : NSObject <MTContainer> {
@protected
    id<MTLoader> _loader;
    NSMutableDictionary* _loadedPages;
    NSMutableDictionary* _pageClasses;
}

- (id)initWithLoader:(id<MTLoader>)loader;

- (id)loadData:(id)data;
- (void)unloadDataWithName:(NSString*)name;

- (void)registerPageClasses:(NSArray*)classes;

// protected
- (Class)classWithName:(NSString*)name;
- (Class)requireClassWithName:(NSString*)name;
- (Class)requireClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName;

@end
