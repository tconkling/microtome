//
// microtome - Copyright 2012 Three Rings Design

#import "MTObjectMarshaller.h"

#import "MTDefs.h"
#import "MTDataElement.h"
#import "MTPage.h"
#import "MTPageRef.h"
#import "MTMutableTome.h"
#import "MTLibrary+Internal.h"
#import "MTTypeInfo.h"
#import "MTProp.h"
#import "MTValidationException.h"

@implementation MTObjectMarshallerBase

- (Class)valueClass {
    MT_IS_ABSTRACT();
    return nil;
}

- (BOOL)handlesSubclasses {
    return NO;
}

- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data {
    MT_IS_ABSTRACT();
    return nil;
}

- (void)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type resolveRefs:(id)value {
    // do nothing by default
}

- (void)validatePropValue:(MTObjectProp*)prop {
    if (!prop.nullable && prop.value == nil) {
        @throw [MTValidationException withProp:prop reason:@"nil value for non-nullable prop"];
    }
    if (prop.value != nil && ![prop.value isKindOfClass:self.valueClass]) {
        @throw [MTValidationException withProp:prop reason:@"incompatible value type [required=%@, actual=%@]",
                        NSStringFromClass(self.valueClass),
                        NSStringFromClass([prop.value class])];
    }
}

@end

// Built-in marshallers

@implementation MTStringMarshaller

- (Class)valueClass { return [NSString class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data {
    return [[MTDataReader withData:data] requireAttribute:@"value"];
}

@end

@implementation MTListMarshaller

- (Class)valueClass { return [NSArray class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    id<MTObjectMarshaller> childMarshaller = [library requireMarshallerForClass:type.subtype.clazz];
    for (id<MTDataElement> childData in [MTDataReader withData:data].children) {
        id child = [childMarshaller withLibrary:library type:type.subtype loadObject:childData];
        [list addObject:child];
    }

    return list;
}

- (void)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type resolveRefs:(id)value {
    NSArray* list = (NSArray*)value;
    id<MTObjectMarshaller> childMarshaller = [library requireMarshallerForClass:type.subtype.clazz];
    for (id child in list) {
        [childMarshaller withLibrary:library type:type.subtype resolveRefs:child];
    }
}

@end

@implementation MTPageMarshaller

- (Class)valueClass { return [MTPage class]; }
- (BOOL)handlesSubclasses { return YES; }

- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data {
    return [library loadPage:data superclass:type.clazz];
}

- (void)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type resolveRefs:(id)value {
    MTPage* page = (MTPage*)value;
    for (MTProp* prop in page.props) {
        if ([prop isKindOfClass:[MTObjectProp class]]) {
            MTObjectProp* objectProp = (MTObjectProp*)prop;
            if (objectProp.value != nil) {
                id<MTObjectMarshaller> propMarshaller = [library requireMarshallerForClass:objectProp.valueType.clazz];
                [propMarshaller withLibrary:library type:objectProp.valueType resolveRefs:objectProp.value];
            }
        }
    }
}

@end

@implementation MTPageRefMarshaller

- (Class)valueClass { return [MTPageRef class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data {
    return [[MTPageRef alloc] initWithPageClass:type.subtype.clazz
                                       pageName:[[MTDataReader withData:data] requireAttribute:@"ref"]];
}

- (void)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type resolveRefs:(id)value {
    MTPageRef* ref = (MTPageRef*)value;
    ref.page = [library requirePageWithQualifiedName:ref.pageName pageClass:ref.pageClass];
}

@end

@implementation MTTomeMarshaller

- (Class)valueClass { return [MTMutableTome class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type loadObject:(id<MTDataElement>)data {
    return [library loadTome:data pageClass:type.subtype.clazz];
}

- (void)withLibrary:(MTLibrary*)library type:(MTTypeInfo*)type resolveRefs:(id)value {
    MTMutableTome* tome = (MTMutableTome*)value;
    id<MTObjectMarshaller> pageMarshaller = [library requireMarshallerForClass:tome.pageClass];
    for (MTPage* page in tome.pages) {
        [pageMarshaller withLibrary:library type:type.subtype resolveRefs:page];
    }
}

@end