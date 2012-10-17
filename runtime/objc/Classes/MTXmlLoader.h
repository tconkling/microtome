//
// microtome - Copyright 2012 Three Rings Design

@protocol MTXmlObjectMarshaller;
@class MTMutablePage;
@class MTLibrary;

@interface MTXmlLoader : NSObject {
@protected
    __weak MTLibrary* _library;
}

- (id)initWithLibrary:(MTLibrary*)library;

- (void)loadPagesFromDoc:(GDataXMLDocument*)doc;
- (void)loadPagesFromDocs:(NSArray*)docs;

// protected

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass;

- (MTMutablePage*)loadPage:(GDataXMLElement*)xml;
- (MTMutablePage*)loadPage:(GDataXMLElement*)xml requiredClass:(Class)requiredClass;

@end
