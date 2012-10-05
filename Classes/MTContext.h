//
// microtome - Copyright 2012 Three Rings Design

@protocol MTPage;
@protocol MTNamedPage;

@interface MTContext : NSObject {
@protected
    NSMutableDictionary* _pageClasses;
}

- (void)registerPageClass:(Class)pageClass;

- (Class)classWithName:(NSString*)name;

// protected
- (Class)requireClassWithName:(NSString*)name;
- (Class)requireClassWithName:(NSString*)name superClass:(Class)superClass;

- (id<MTPage>)getPage:(NSString*)name fromLibrary:(id<MTPage>)library;

@end
