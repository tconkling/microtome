//
// microtome - Copyright 2012 Three Rings Design

#import "MTContext.h"

#import "MTPage.h"
#import "MTProp.h"
#import "MTLoadException.h"

@implementation MTContext

- (id)init {
    if ((self = [super init])) {
        _pageClasses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerPageClass:(Class)pageClass {
    if (![pageClass conformsToProtocol:@protocol(MTPage)]) {
        [NSException raise:NSGenericException format:@"Class must implement %@ [pageClass=%@]",
             NSStringFromProtocol(@protocol(MTPage)), NSStringFromClass(pageClass)];
    }

    _pageClasses[NSStringFromClass(pageClass)] = pageClass;
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

- (id<MTNamedPage>)getNamedPage:(NSString*)name fromLibrary:(id<MTPage>)library {

}

@end
