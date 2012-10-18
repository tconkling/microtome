//
// microtome - Copyright 2012 Three Rings Design

#import "MTUtils.h"

#import "MTDefs.h"
#import "MTLibrary.h"
#import "MTTome.h"
#import "MTPage.h"
#import "MTProp.h"

BOOL MTValidLibraryItemName (NSString* name) {
    return [name rangeOfString:MT_NAME_SEPARATOR].location == NSNotFound;
}

MTProp* MTGetProp (id<MTPage> page, NSString* name) {
    return [page.props findObject:^BOOL(MTProp* prop) {
        return [prop.name isEqualToString:name];
    }];
}