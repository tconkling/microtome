//
// microtome - Copyright 2012 Three Rings Design

@class MTType;
@class MTLibrary;
@class MTLibrary;
@class MTProp;

@protocol MTObjectMarshaller <NSObject>

@property (nonatomic,readonly) Class valueType;
@property (nonatomic,readonly) BOOL handlesSubclasses;

/// loads an object from XML
- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml;

/// Resolves PageRefs contained within an object
- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value;

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