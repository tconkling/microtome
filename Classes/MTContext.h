//
// microtome - Copyright 2012 Three Rings Design

#import "MTContainer.h"

@protocol MTPage;

@interface MTContext : NSObject <MTContainer> {
@protected
    NSMutableDictionary* _loadedPages;
    NSMutableDictionary* _pageClasses;
}

- (id)loadData:(id)data withName:(NSString*)name;
- (void)unloadDataWithName:(NSString*)name;

- (void)registerPageClass:(Class)pageClass;

// protected
- (Class)classWithName:(NSString*)name;
- (Class)requireClassWithName:(NSString*)name;
- (Class)requireClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName;

// abstract
- (id<MTPage>)pageFromData:(id)data withName:(NSString*)name;

@end
