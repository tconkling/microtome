//
// microtome - Copyright 2012 Three Rings Design

@class MTProp;
@protocol MTPage;

BOOL MTValidLibraryItemName (NSString* name);
MTProp* MTGetProp (id<MTPage> page, NSString* name);
