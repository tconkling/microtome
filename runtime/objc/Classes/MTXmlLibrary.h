//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibrary.h"

@protocol MTXmlObjectMarshaller;
@class MTMutablePage;
@class MTMutableTome;
@class MTLibrary;
@class MTXmlLoadTask;

@interface MTXmlLibrary : MTLibrary {
@protected
    MTXmlLoadTask* _loadTask;
}

/// loads the given files into the library.
- (void)loadFiles:(NSArray*)filenames;

/// loads the given GDataXMLDocuments into the library.
- (void)loadXmlDocs:(NSArray*)docs;

@end
