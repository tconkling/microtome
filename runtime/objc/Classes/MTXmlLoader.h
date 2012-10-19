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

- (void)loadItemsFromDoc:(GDataXMLDocument*)doc;
- (void)loadItemsFromDocs:(NSArray*)docs;

// protected

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass;

- (MTMutableTome*)loadTome:(GDataXMLElement*)xml pageType:(__unsafe_unretained Class)pageType;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml superclass:(Class)superclass;

@end
