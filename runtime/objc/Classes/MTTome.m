//
// microtome - Copyright 2012 Three Rings Design

#import "MTTome.h"

#import "MTPage.h"

@implementation MTMutableTome

@synthesize pageType = _pageType;

- (id)initWithPageType:(Class)pageType {
    if ((self = [super init])) {
        _pageType = pageType;
        _pages = [[NSMutableDictionary alloc] init];
    }
    return self;
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

- (id<MTPage>)pageNamed:(NSString*)name {
    return _pages[name];
}

- (id<MTPage>)requirePageNamed:(NSString*)name {
    id<MTPage> page = [self pageNamed:name];
    if (page == nil) {
        [NSException raise:NSGenericException format:@"Missing required page [name=%@]", name];
    }
    return page;
}

- (void)addPage:(id<MTPage>)page {
    if (page == nil) {
        [NSException raise:NSGenericException format:@"Can't add nil page"];
    } else if (![page isKindOfClass:_pageType]) {
        [NSException raise:NSGenericException
                    format:@"Incorrect page type [required=%@, got=%@]", _pageType, [page class]];
    } else if (page.name == nil) {
        [NSException raise:NSGenericException
                    format:@"NamedPage is missing name [type=%@]", [page class]];
    } else if ([self pageNamed:page.name] != nil) {
        [NSException raise:NSGenericException format:@"Duplicate page name [name=%@]", page.name];
    }

    _pages[page.name] = page;
}

@end
