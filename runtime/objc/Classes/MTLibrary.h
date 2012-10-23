//
// microtome - Copyright 2012 Three Rings Design

@protocol MTObjectMarshaller;
@protocol MTPrimitiveMarshaller;
@class MTLoadTask;

@interface MTLibrary : NSObject {
@protected
    NSMutableDictionary* _items;
    NSMutableDictionary* _pageClasses;
    NSMutableDictionary* _objectMarshallers;
    id<MTPrimitiveMarshaller> _primitiveMarshaller;
    MTLoadTask* _loadTask;
}

@property (nonatomic,strong) id<MTPrimitiveMarshaller> primitiveMarshaller;

/// loads the given files into the library.
- (void)loadFiles:(NSArray*)filenames;

/// loads the given GDataXMLDocuments into the library.
- (void)loadXmlDocs:(NSArray*)docs;

/// Removes all items from the library
- (void)removeAllItems;

- (void)registerPageClasses:(NSArray*)classes;
- (void)registerObjectMarshaller:(id<MTObjectMarshaller>)marshaller;

/// FooPage* page = library[@"myFooPage"] or
/// id<MTTome> tome = library[@"myTomeyTome"]
- (id)objectForKeyedSubscript:(id)key;

@end
