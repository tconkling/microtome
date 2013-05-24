//
// microtome - Copyright 2012 Three Rings Design

#import "MTPrimitiveMarshaller.h"

#import "MTDefs.h"
#import "MTProp.h"
#import "MTValidationException.h"

@implementation MTDefaultPrimitiveMarshaller

- (void)validateBool:(MTBoolProp*)prop {
    // do nothing
}

- (void)validateInt:(MTIntProp*)prop {
    int min = [prop intAnnotation:MT_MIN_ANNOTATION default:INT_MIN];
    if (prop.value < min) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%d < %d)", prop.value, min];
    }
    int max = [prop intAnnotation:MT_MAX_ANNOTATION default:INT_MAX];
    if (prop.value > max) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%d < %d)", prop.value, min];
    }
}

- (void)validateFloat:(MTFloatProp*)prop {
    float min = [prop floatAnnotation:MT_MIN_ANNOTATION default:-FLT_MAX];
    if (prop.value < min) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%g < %g)", prop.value, min];
    }
    float max = [prop floatAnnotation:MT_MAX_ANNOTATION default:FLT_MAX];
    if (prop.value > max) {
        @throw [MTValidationException withProp:prop reason:@"value too small (%g < %g)", prop.value, min];
    }
}

@end
