//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"

#import "MTDefs.h"
#import "MTType.h"

@implementation MTPropSpec

@synthesize name = _name;
@synthesize annotations = _annotations;
@synthesize valueType = _valueType;

- (id)initWithName:(NSString*)name annotations:(NSDictionary*)annotations valueTypes:(NSArray*)valueTypes {
    if ((self = [super init])) {
        _name = name;
        _annotations = annotations;
        _valueType = (valueTypes == nil ? nil : MTBuildType(valueTypes));
    }
    return self;
}

@end

@implementation MTProp

- (id)initWithPropSpec:(MTPropSpec*)spec {
    if ((self = [super init])) {
        _spec = spec;
    }
    return self;
}

- (NSString*)name {
    return _spec.name;
}

- (BOOL)hasAnnotation:(NSString*)name {
    return _spec.annotations[name] != nil;
}

- (BOOL)boolAnnotation:(NSString*)name default:(BOOL)defaultVal {
    id val = _spec.annotations[name];
    if (![val isKindOfClass:[NSNumber class]]) {
        return defaultVal;
    } else {
        return ((NSNumber*)val).boolValue;
    }
}

- (float)floatAnnotation:(NSString*)name default:(float)defaultVal {
    id val = _spec.annotations[name];
    if (![val isKindOfClass:[NSNumber class]]) {
        return defaultVal;
    } else {
        return ((NSNumber*)val).floatValue;
    }
}

- (int)intAnnotation:(NSString*)name default:(int)defaultVal {
    id val = _spec.annotations[name];
    if (![val isKindOfClass:[NSNumber class]]) {
        return defaultVal;
    } else {
        return ((NSNumber*)val).intValue;
    }
}

- (NSString*)stringAnnotation:(NSString*)name default:(NSString*)defaultVal {
    id val = _spec.annotations[name];
    if (![val isKindOfClass:[NSString class]]) {
        return defaultVal;
    } else {
        return (NSString*)val;
    }
}

@end

@implementation MTObjectProp

@synthesize value = _value;

- (MTType*)valueType {
    return _spec.valueType;
}

- (BOOL)nullable {
    return [self boolAnnotation:MT_NULLABLE default:NO];
}

@end

@implementation MTBoolProp
@end

@implementation MTIntProp
@end

@implementation MTFloatProp
@end