//
// microtome - Copyright 2012 Three Rings Design

#import "MTValueHandler.h"

#import "MTDefs.h"
#import "MTMutablePage.h"
#import "MTMutablePageRef.h"
#import "MTMutableTome.h"
#import "MTLibrary.h"
#import "MTType.h"
#import "MTProp.h"
#import "MTValidationException.h"

@implementation MTValueHandlerBase

- (Class)valueType {
    MT_IS_ABSTRACT();
    return nil;
}

- (BOOL)handlesSubclasses {
    MT_IS_ABSTRACT();
    return NO;
}

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    // do nothing by default
}

- (void)validatePropValue:(MTObjectProp*)prop {
    if (!prop.nullable && prop.value == nil) {
        @throw [MTValidationException withProp:prop reason:@"nil value for non-nullable prop"];
    }
    if (prop.value != nil && ![prop.value isKindOfClass:self.valueType]) {
        @throw [MTValidationException withProp:prop reason:@"incompatible value type [required=%@, actual=%@]",
                        NSStringFromClass(self.valueType),
                        NSStringFromClass([prop.value class])];
    }
}

@end

// Built-in value handlers

@implementation MTDefaultPrimitiveValueHandler

#define MT_TOO_SMALL(prop, min) \
    ({ [MTValidationException withProp:prop reason:@"value too small (%d < %d)", prop.value, min]; })
#define MT_TOO_LARGE(prop, max) \
    ({ [MTValidationException withProp:prop reason:@"value too large (%d > %d)", prop.value, max]; })

- (void)validateBool:(MTBoolProp*)prop {
    // do nothing
}

- (void)validateInt:(MTIntProp*)prop {
    int min = [prop intAnnotation:MT_MIN default:INT_MIN];
    if (prop.value < min) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%d < %d)", prop.value, min];
    }
    int max = [prop intAnnotation:MT_MAX default:INT_MAX];
    if (prop.value > max) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%d < %d)", prop.value, min];
    }
}

- (void)validateFloat:(MTFloatProp*)prop {
    float min = [prop floatAnnotation:MT_MIN default:-FLT_MAX];
    if (prop.value < min) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%g < %g)", prop.value, min];
    }
    float max = [prop floatAnnotation:MT_MAX default:FLT_MAX];
    if (prop.value > max) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%g < %g)", prop.value, min];
    }
}

@end

@implementation MTStringValueHandler

- (Class)valueType { return [NSString class]; }
- (BOOL)handlesSubclasses { return NO; }

@end

@implementation MTListValueHandler

- (Class)valueType { return [NSArray class]; }
- (BOOL)handlesSubclasses { return NO; }

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    NSArray* list = (NSArray*)value;
    id<MTValueHandler> childHandler = [library requireValueHandlerForClass:type.subtype.clazz];
    for (id child in list) {
        [childHandler withLibrary:library type:type.subtype resolveRefs:child];
    }
}

@end

@implementation MTPageValueHandler

- (Class)valueType { return [MTMutablePage class]; }
- (BOOL)handlesSubclasses { return YES; }

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    MTMutablePage* page = (MTMutablePage*)value;
    for (MTProp* prop in page.props) {
        if ([prop isKindOfClass:[MTObjectProp class]]) {
            MTObjectProp* objectProp = (MTObjectProp*)prop;
            if (objectProp.value != nil) {
                id<MTValueHandler> propHandler = [library requireValueHandlerForClass:objectProp.valueType.clazz];
                [propHandler withLibrary:library type:objectProp.valueType resolveRefs:objectProp.value];
            }
        }
    }
}

@end

@implementation MTPageRefValueHandler

- (Class)valueType { return [MTMutablePageRef class]; }
- (BOOL)handlesSubclasses { return NO; }

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    MTMutablePageRef* ref = (MTMutablePageRef*)value;
    ref.page = [library requirePage:ref.pageName pageClass:ref.pageType];
}

@end

@implementation MTTomeValueHandler

- (Class)valueType { return [MTMutableTome class]; }
- (BOOL)handlesSubclasses { return NO; }

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    MTMutableTome* tome = (MTMutableTome*)value;
    id<MTValueHandler> pageHandler = [library requireValueHandlerForClass:tome.pageType];
    for (id<MTPage> page in tome.pages) {
        [pageHandler withLibrary:library type:type.subtype resolveRefs:page];
    }
}

@end