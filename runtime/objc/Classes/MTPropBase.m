//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@implementation MTPropBase

@synthesize name = _name;
@synthesize parent = _parent;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent {
    if ((self = [super init])) {
        _name = name;
        _parent = parent;
    }
    return self;
}

- (void)resolveRefs:(MTLibrary*)library {
    // by default, do nothing
}

@end

@implementation MTObjectPropBase

@synthesize value = _value;
@synthesize nullable = _nullable;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable {
    if ((self = [super initWithName:name parent:parent])) {
        _nullable = nullable;
    }
    return self;
}

- (void)setValue:(id)value {
    _value = value;
    [self validate];
}

- (Class)valueType {
    OOO_IS_ABSTRACT();
    return nil;
}

- (void)validate {
    if (_value != nil && ![_value isKindOfClass:self.valueType]) {
        [NSException raise:NSGenericException
                    format:@"Incompatible value type [required=%@, got=%@]", self.valueType, [_value class]];
    }
}

@end

@implementation MTParameterizedObjectPropBase

@synthesize subType = _subType;

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable subType:(Class)subType {
    if ((self = [super initWithName:name parent:parent nullable:nullable])) {
        _subType = subType;
    }
    return self;
}

@end