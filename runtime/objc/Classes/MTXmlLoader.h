//
// microtome - Copyright 2012 Three Rings Design

@protocol MTXmlObjectMarshaller;
@class MTMutablePage;
@class MTMutableTome;
@class MTLibrary;

@interface MTXmlLoader : NSObject {
@protected
    __weak MTLibrary* _library;
}

- (id)initWithLibrary:(MTLibrary*)library;

/// loads the given files into the library.
/// Filenames is an array of NSString file paths
- (void)loadFiles:(NSArray*)filenames;
/// loads the given GDataXMLDocuments into the library.
- (void)loadXmlDocs:(NSArray*)docs;

// protected

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass;

- (MTMutableTome*)loadTome:(GDataXMLElement*)xml pageType:(__unsafe_unretained Class)pageType;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml superclass:(Class)superclass;

@end
