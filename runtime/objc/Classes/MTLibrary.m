//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

#import "MTLoader.h"
#import "MTDefs.h"
#import "MTUtils.h"
#import "MTPage.h"
#import "MTProp.h"
#import "MTValueHandler.h"
#import "MTTome.h"
#import "MTType.h"
#import "MTLoadException.h"

@implementation MTLibrary

- (id)initWithLoader:(id<MTLoader>)loader {
    if ((self = [super init])) {
        _loader = loader;
        _pageClasses = [[NSMutableDictionary alloc] init];
        _loadedPages = [[NSMutableDictionary alloc] init];
        _valueHandlers = [[NSMutableDictionary alloc] init];

        [self registerValueHandler:[[MTStringValueHandler alloc] init]];
        [self registerValueHandler:[[MTListValueHandler alloc] init]];
        [self registerValueHandler:[[MTPageValueHandler alloc] init]];
        [self registerValueHandler:[[MTPageRefValueHandler alloc] init]];
        [self registerValueHandler:[[MTTomeValueHandler alloc] init]];
    }
    return self;
}

// MTContainer
- (id)childNamed:(NSString*)name {
    return _loadedPages[name];
}

- (void)registerValueHandler:(id<MTValueHandler>)handler {
    _valueHandlers[(id<NSCopying>)handler.valueType] = handler;
}

- (id<MTValueHandler>)requireValueHandlerForClass:(Class)requiredClass {
    id<MTValueHandler> handler = _valueHandlers[requiredClass];
    if (handler == nil) {
        // if we can't find an exact match, see if we have a handler for a superclass that
        // can take subclasses
        for (id<MTValueHandler> candidate in _valueHandlers.objectEnumerator) {
            if (candidate.handlesSubclasses && [requiredClass isSubclassOfClass:candidate.valueType]) {
                _valueHandlers[(id<NSCopying>)requiredClass] = candidate;
                handler = candidate;
                break;
            }
        }
    }

    if (handler == nil) {
        [NSException raise:NSGenericException format:@"No handler for '%@'",
            NSStringFromClass(requiredClass)];
    }

    return handler;
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
        id<MTValueHandler> handler = [self requireValueHandlerForClass:[page class]];
        [handler withLibrary:self type:[[MTType alloc] initWithClass:[page class] subtype:nil] resolveRefs:page];
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

- (Class)pageClassWithName:(NSString*)name {
    return _pageClasses[name];
}

- (Class)requirePageClassWithName:(NSString*)name {
    Class clazz = _pageClasses[name];
    if (clazz == nil) {
        @throw [MTLoadException withReason:@"No page class for name [name=%@]", name];
    }
    return clazz;
}

- (Class)requirePageClassWithName:(NSString*)name superClass:(__unsafe_unretained Class)superClass {
    Class clazz = [self requirePageClassWithName:name];
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

- (id<MTPage>)requirePage:(NSString*)fullyQualifiedName pageClass:(Class)pageClass {
    id<MTPage> page = [self getPage:fullyQualifiedName];
    if (page == nil) {
        [NSException raise:NSGenericException format:@"Missing required page [name=%@]", fullyQualifiedName];
    }

    if (![page isKindOfClass:pageClass]) {
        [NSException raise:NSGenericException
                    format:@"Wrong type for required page [name=%@ expectedType=%@ actualType=%@]",
                        fullyQualifiedName, NSStringFromClass(pageClass),
                        NSStringFromClass([page class])];
    }

    return page;
}

@end
