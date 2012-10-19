//
// microtome - Copyright 2012 Three Rings Design

@class MTType;
@class MTLibrary;
@class MTProp;
@class MTBoolProp;
@class MTIntProp;
@class MTFloatProp;

@protocol MTPrimitiveValueHandler <NSObject>
/// throws an MTValidationException on failure
- (void)validateBool:(MTBoolProp*)prop;
/// throws an MTValidationException on failure
- (void)validateInt:(MTIntProp*)prop;
/// throws an MTValidationException on failure
- (void)validateFloat:(MTFloatProp*)prop;
@end

@protocol MTValueHandler <NSObject>
@property (nonatomic,readonly) Class valueType;
@property (nonatomic,readonly) BOOL handlesSubclasses;
- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value;
/// throws an MTValidationException on failure
- (void)validatePropValue:(MTProp*)prop;
@end

// abstract
@interface MTValueHandlerBase : NSObject <MTValueHandler>
@end

/// Built-in value handlers
@interface MTDefaultPrimitiveValueHandler : NSObject <MTPrimitiveValueHandler>
@end

@interface MTStringValueHandler : MTValueHandlerBase
@end

@interface MTListValueHandler : MTValueHandlerBase
@end

@interface MTPageValueHandler : MTValueHandlerBase
@end

@interface MTPageRefValueHandler : MTValueHandlerBase
@end

@interface MTTomeValueHandler : MTValueHandlerBase
@end