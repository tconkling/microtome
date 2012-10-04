//
// microtome - Copyright 2012 Three Rings Design

#import "MTUtils.h"

#import "MTPage.h"
#import "MTProp.h"

BOOL MTValidPageName (NSString* name) {
    return [name rangeOfString:@"."].location == NSNotFound;
}

id<MTProp> MTGetProp (id<MTPage> page, NSString* name) {
    return [page.props findObject:^BOOL(id<MTProp> prop) {
        return [prop.name isEqualToString:name];
    }];
}
