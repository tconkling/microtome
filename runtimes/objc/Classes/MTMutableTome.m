//
// microtome - Copyright 2012 Three Rings Design

#import "MTMutableTome.h"

#import "MTTypeInfo.h"
#import "MTPage.h"

@implementation MTMutableTome

@synthesize name = _name;
@synthesize typeInfo = _typeInfo;

- (id)initWithName:(NSString*)name pageClass:(Class)pageClass {
    if ((self = [super init])) {
        _name = name;
        _typeInfo = MTBuildTypeInfo(@[[self class], pageClass]);
        _pages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (Class)pageClass {
    return _typeInfo.subtype.clazz;
}

- (int)pageCount {
    return _pages.count;
}

- (id<NSFastEnumeration>)pages {
    return [_pages objectEnumerator];
}

// MTContainer
- (id)childNamed:(NSString*)name {
    return [self pageNamed:name];
}

- (MTPage*)pageNamed:(NSString*)name {
    return _pages[name];
}

- (MTPage*)requirePageNamed:(NSString*)name {
    MTPage* page = [self pageNamed:name];
    if (page == nil) {
        [NSException raise:NSGenericException format:@"Missing required page [name=%@]", name];
    }
    return page;
}

- (void)addPage:(MTPage*)page {
    if (page == nil) {
        [NSException raise:NSGenericException format:@"Can't add nil page"];
    } else if (![page isKindOfClass:self.pageClass]) {
        [NSException raise:NSGenericException
                    format:@"Incorrect page type [required=%@, got=%@]", self.pageClass, [page class]];
    } else if (page.name == nil) {
        [NSException raise:NSGenericException
                    format:@"Page is missing name [type=%@]", [page class]];
    } else if ([self pageNamed:page.name] != nil) {
        [NSException raise:NSGenericException format:@"Duplicate page name [name=%@]", page.name];
    }

    _pages[page.name] = page;
}

@end
