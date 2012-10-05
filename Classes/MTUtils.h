//
// microtome - Copyright 2012 Three Rings Design

@class MTLibrary;
@protocol MTPage;
@protocol MTProp;
@protocol MTTome;

BOOL MTValidPageName (NSString* name);
id<MTProp> MTGetProp (id<MTPage> page, NSString* name);
void MTResolvePageRefs (id<MTPage> page, MTLibrary* library);
void MTResolveTomeRefs (id<MTTome> tome, MTLibrary* library);
