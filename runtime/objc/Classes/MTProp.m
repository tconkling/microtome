//
// microtome - Copyright 2012 Three Rings Design

#import "MTProp.h"
#import "MTType.h"

@implementation MTProp

@synthesize name = _name;

- (id)initWithName:(NSString*)name {
    if ((self = [super init])) {
        _name = name;
    }
    return self;
}

- (void)resolveRefs:(MTLibrary*)library {
    // do nothing by default
}

@end

@implementation MTObjectProp

@synthesize valueType = _valueType;
@synthesize value = _value;
@synthesize nullable = _nullable;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable valueType:(MTType*)valueType {
    if ((self = [super initWithName:name])) {
        _nullable = nullable;
        _valueType = valueType;
    }
    return self;
}

- (void)setValue:(id)value {
    _value = value;
    [self validate];
}

- (void)validate {
    if (_value != nil && ![_value isKindOfClass:_valueType.clazz]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible value type [required=%@, got=%@]", self.valueType, [_value class]];
    }
}

@end

@implementation MTBoolProp
@end

@implementation MTIntProp
@end

@implementation MTFloatProp
@end