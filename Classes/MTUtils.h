//
// microtome - Copyright 2012 Three Rings Design

@protocol MTPage;
@protocol MTProp;

BOOL MTValidPageName (NSString* name);
id<MTProp> MTGetProp (id<MTPage> page, NSString* name);
