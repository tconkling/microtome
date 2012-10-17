//
// microtome - Copyright 2012 Three Rings Design

@class MTType;
@class MTLibrary;
@class MTObjectProp;

@protocol MTValueHandler <NSObject>
@property (nonatomic,readonly) Class valueType;
@property (nonatomic,readonly) BOOL handlesSubclasses;
- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value;
- (void)validatePropValue:(MTObjectProp*)prop;
@end

// abstract
@interface MTValueHandlerBase : NSObject <MTValueHandler>
@end

/// Built-in value handlers
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