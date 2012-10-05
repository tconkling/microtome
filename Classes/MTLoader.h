//
// microtome - Copyright 2012 Three Rings Design

@class MTLibrary;
@class MTMutablePage;

@protocol MTLoader
- (MTMutablePage*)withLibrary:(MTLibrary*)library loadPage:(id)data;
@end
