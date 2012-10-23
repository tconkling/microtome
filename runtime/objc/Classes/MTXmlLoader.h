//
// microtome - Copyright 2012 Three Rings Design

@protocol MTXmlObjectMarshaller;
@class MTMutablePage;
@class MTMutableTome;
@class MTLibrary;
@class MTXmlLoadTask;

@interface MTXmlLoader : NSObject {
@protected
    __weak MTLibrary* _library;
    MTXmlLoadTask* _loadTask;
}

- (id)initWithLibrary:(MTLibrary*)library;

/// loads the given files into the library.
- (void)loadFiles:(NSArray*)filenames;

/// loads the given GDataXMLDocuments into the library.
- (void)loadXmlDocs:(NSArray*)docs;

@end
