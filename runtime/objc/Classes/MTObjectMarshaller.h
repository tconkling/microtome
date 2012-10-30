//
// microtome - Copyright 2012 Three Rings Design

@protocol MTDataElement;
@class MTTypeInfo;
@class MTLibrary;
@class MTLibrary;
@class MTProp;

@protocol MTObjectMarshaller <NSObject>

@property (nonatomic,readonly) Class valueClass;
@property (nonatomic,readonly) BOOL handlesSubclasses;

/// loads an object from a data element
- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data;

/// Resolves PageRefs contained within an object
- (void)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type resolveRefs:(id)value;

/// Validates an object's value. Throws an MTValidationException on failure
- (void)validatePropValue:(MTProp*)prop;
@end

// abstract
@interface MTObjectMarshallerBase : NSObject <MTObjectMarshaller>
@end

/// Built-in marshallers
@interface MTStringMarshaller : MTObjectMarshallerBase
@end

@interface MTListMarshaller : MTObjectMarshallerBase
@end

@interface MTPageMarshaller : MTObjectMarshallerBase
@end

@interface MTPageRefMarshaller : MTObjectMarshallerBase
@end

@interface MTTomeMarshaller : MTObjectMarshallerBase
@end