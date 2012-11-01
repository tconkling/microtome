//
// microtome - Copyright 2012 Three Rings Design

@class MTBoolProp;
@class MTIntProp;
@class MTFloatProp;

@protocol MTPrimitiveMarshaller <NSObject>
/// throws an MTValidationException on failure
- (void)validateBool:(MTBoolProp*)prop;
/// throws an MTValidationException on failure
- (void)validateInt:(MTIntProp*)prop;
/// throws an MTValidationException on failure
- (void)validateFloat:(MTFloatProp*)prop;
@end

// default marshaller
@interface MTDefaultPrimitiveMarshaller : NSObject <MTPrimitiveMarshaller>
@end