//
// microtome - Copyright 2012 Three Rings Design

#import "MTUtils.h"

#import "MTDefs.h"
#import "MTLibrary.h"
#import "MTTome.h"
#import "MTPage.h"
#import "MTProp.h"

BOOL MTValidPageName (NSString* name) {
    return [name rangeOfString:MT_NAME_SEPARATOR].location == NSNotFound;
}

id<MTProp> MTGetProp (id<MTPage> page, NSString* name) {
    return [page.props findObject:^BOOL(id<MTProp> prop) {
        return [prop.name isEqualToString:name];
    }];
}

void MTResolvePageRefs (id<MTPage> page, MTLibrary* library) {
    for (id<MTProp> prop in page.props) {
        [prop resolveRefs:library];
    }
}

void MTResolveTomeRefs (id<MTTome> tome, MTLibrary* library) {
    for (id<MTPage> page in tome.pages) {
        MTResolvePageRefs(page, library);
    }
}
