//
// microtome - Copyright 2012 Three Rings Design

#import "MTPrimitiveMarshaller.h"

#import "MTDefs.h"
#import "MTProp.h"
#import "MTValidationException.h"

@implementation MTDefaultPrimitiveMarshaller

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
