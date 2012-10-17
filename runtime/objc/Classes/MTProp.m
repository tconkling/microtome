//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"
#import "MTType.h"

@implementation MTPropSpec

@synthesize name = _name;

- (id)initWithName:(NSString*)name {
    if ((self = [super init])) {
        _name = name;
    }
    return self;
}

@end

@implementation MTObjectPropSpec

@synthesize nullable = _nullable;
@synthesize valueType = _valueType;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable valueType:(MTType*)valueType {
    if ((self = [super initWithName:name])) {
        _nullable = nullable;
        _valueType = valueType;
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

@end

@implementation MTObjectProp

@synthesize value = _value;

- (BOOL)nullable {
    return ((MTObjectPropSpec*)_spec).nullable;
}

- (MTType*)valueType {
    return ((MTObjectPropSpec*)_spec).valueType;
}

- (void)setValue:(id)value {
    _value = value;
    [self validate];
}

- (void)validate {
    if (_value != nil && ![_value isKindOfClass:self.valueType.clazz]) {
        [NSException raise:NSGenericException
            format:@"Incompatible value type [required=%@, got=%@]",
            self.valueType.clazz, [_value class]];
    }
}

@end

@implementation MTBoolProp
@end

@implementation MTIntProp
@end

@implementation MTFloatProp
@end
