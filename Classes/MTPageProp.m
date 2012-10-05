//
// microtome - Copyright 2012 Three Rings Design

#import "MTPageProp.h"

#import "MTPage.h"
#import "MTUtils.h"

@implementation MTMutablePageProp

@synthesize pageType = _pageType;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable pageType:(Class)pageType {
    if ((self = [super initWithName:name parent:parent type:[NSObject class] nullable:nullable])) {
        _pageType = pageType;
    }
    return self;
}

- (void)validateValue:(id)val {
    [super validateValue:val];
    if (![[val class] isSubclassOfClass:_pageType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible page (pageType '%@' is not a subclass of '%@')",
         [val class], _pageType];
    }
}

- (void)resolveRefs:(MTLibrary*)library {
    MTMutablePage* page = (MTMutablePage*)_value;
    if (page != nil) {
        MTResolvePageRefs(page, library);
    }
}

@end
