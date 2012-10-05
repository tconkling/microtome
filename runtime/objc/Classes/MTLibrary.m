//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

#import "MTLoader.h"
#import "MTDefs.h"
#import "MTUtils.h"
#import "MTPage.h"
#import "MTProp.h"
#import "MTTome.h"
#import "MTLoadException.h"

@implementation MTLibrary

- (id)initWithLoader:(id<MTLoader>)loader {
    if ((self = [super init])) {
        _loader = loader;
        _pageClasses = [[NSMutableDictionary alloc] init];
        _loadedPages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// MTContainer
- (id)childNamed:(NSString*)name {
    return _loadedPages[name];
}

- (void)registerPageClasses:(NSArray*)classes {
    for (Class pageClass in classes) {
        if (![pageClass conformsToProtocol:@protocol(MTPage)]) {
            [NSException raise:NSGenericException format:@"Class must implement %@ [pageClass=%@]",
             NSStringFromProtocol(@protocol(MTPage)), NSStringFromClass(pageClass)];
        }

        _pageClasses[NSStringFromClass(pageClass)] = pageClass;
    }
}

- (id)loadData:(id)data {
    MTMutablePage* page = [_loader withLibrary:self loadPage:data];
    if (_loadedPages[page.name] != nil) {
        [NSException raise:NSGenericException
                    format:@"Data with that name is already loaded [name=%@]", page.name];
    }
    
    _loadedPages[page.name] = page;
    
    @try {
        for (id<MTProp> prop in page.props) {
            [prop resolveRefs:self];
        }
    }
    @catch (NSException* exception) {
        [self unloadDataWithName:page.name];
        @throw exception;
    }

    return page;
}

- (void)unloadDataWithName:(NSString*)name {
    [_loadedPages removeObjectForKey:name];
}

- (Class)classWithName:(NSString*)name {
    return _pageClasses[name];
}

- (Class)requireClassWithName:(NSString*)name {
    Class clazz = _pageClasses[name];
    if (clazz == nil) {
        @throw [MTLoadException withReason:@"No page class for name [name=%@]", name];
    }
    return clazz;
}

- (Class)requireClassWithName:(NSString*)name superClass:(__unsafe_unretained Class)superClass {
    Class clazz = [self requireClassWithName:name];
    if (![clazz isSubclassOfClass:superClass]) {
        @throw [MTLoadException withReason:@"Unexpected page class [required=%@, got=%@]",
                NSStringFromClass(superClass), NSStringFromClass(clazz)];
    }
    return clazz;
}

- (id<MTPage>)getPage:(NSString*)fullyQualifiedName {
    // A page's fullyQualifiedName is a series of page and tome names, separated by dots
    // E.g. level1.baddies.big_boss
    
    NSArray* components = [fullyQualifiedName componentsSeparatedByString:MT_NAME_SEPARATOR];
    id<MTContainer> container = self;
    for (NSString* name in components) {
        id child = [container childNamed:name];
        if (![child conformsToProtocol:@protocol(MTContainer)]) {
            return nil;
        }
        container = (id<MTContainer>)child;
    }

    return ([container conformsToProtocol:@protocol(MTPage)] ? (id<MTPage>)container : nil);
}

@end
