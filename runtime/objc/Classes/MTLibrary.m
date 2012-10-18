//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

#import "MTDefs.h"
#import "MTUtils.h"
#import "MTPage.h"
#import "MTProp.h"
#import "MTValueHandler.h"
#import "MTTome.h"
#import "MTType.h"
#import "MTLoadException.h"

@implementation MTLibrary

- (id)init {
    if ((self = [super init])) {
        _pageClasses = [[NSMutableDictionary alloc] init];
        _items = [[NSMutableDictionary alloc] init];
        _valueHandlers = [[NSMutableDictionary alloc] init];

        [self registerValueHandler:[[MTStringValueHandler alloc] init]];
        [self registerValueHandler:[[MTListValueHandler alloc] init]];
        [self registerValueHandler:[[MTPageValueHandler alloc] init]];
        [self registerValueHandler:[[MTPageRefValueHandler alloc] init]];
        [self registerValueHandler:[[MTTomeValueHandler alloc] init]];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    return _items[key];
}

- (void)removeAllItems {
    [_items removeAllObjects];
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

- (void)addItems:(NSArray*)items {
    for (id<MTLibraryItem> item in items) {
        if (_items[item.name] != nil) {
            [NSException raise:NSGenericException
                        format:@"An item with that name is already loaded [item=%@]", item.name];
        }
    }

    for (id<MTLibraryItem> item in items) {
        _items[item.name] = item;
    }

    @try {
        for (id<MTLibraryItem> item in items) {
            id<MTValueHandler> handler = [self requireValueHandlerForClass:[item class]];
            [handler withLibrary:self type:item.type resolveRefs:item];
        }
    }
    @catch (NSException* exception) {
        for (id<MTLibraryItem> item in items) {
            [self removeItemWithName:item.name];
        }
        @throw exception;
    }
}

- (void)removeItemWithName:(NSString*)name {
    [_items removeObjectForKey:name];
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
    id<MTLibraryItem> item = nil;
    for (NSString* name in components) {
        id child = (item != nil ? [item childNamed:name] : self[name]);
        if (![child conformsToProtocol:@protocol(MTLibraryItem)]) {
            return nil;
        }
        item = (id<MTLibraryItem>)child;
    }

    return ([item conformsToProtocol:@protocol(MTPage)] ? (id<MTPage>)item : nil);
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
