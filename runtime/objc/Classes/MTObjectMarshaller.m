//
// microtome - Copyright 2012 Three Rings Design

#import "MTObjectMarshaller.h"

#import "MTDefs.h"
#import "MTMutablePage.h"
#import "MTMutablePageRef.h"
#import "MTMutableTome.h"
#import "MTLibrary+Internal.h"
#import "MTType.h"
#import "MTProp.h"
#import "MTValidationException.h"

@implementation MTObjectMarshallerBase

- (Class)valueType {
    MT_IS_ABSTRACT();
    return nil;
}

- (BOOL)handlesSubclasses {
    return NO;
}

- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    MT_IS_ABSTRACT();
    return nil;
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

@implementation MTStringMarshaller

- (Class)valueType { return [NSString class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSString* val = xml.stringValue;
    // handle the empty string (<myStringProp></myStringProp>)
    if (val == nil) {
        val = @"";
    }
    return val;
}

@end

@implementation MTListMarshaller

- (Class)valueType { return [NSArray class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (GDataXMLElement* childXml in xml.elements) {
        id<MTObjectMarshaller> marshaller = [library requireMarshallerForClass:type.subtype.clazz];
        id child = [marshaller withLibrary:library type:type.subtype loadObjectfromXml:childXml];
        [list addObject:child];
    }

    return list;
}

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    NSArray* list = (NSArray*)value;
    id<MTObjectMarshaller> childHandler = [library requireMarshallerForClass:type.subtype.clazz];
    for (id child in list) {
        [childHandler withLibrary:library type:type.subtype resolveRefs:child];
    }
}

@end

@implementation MTPageMarshaller

- (Class)valueType { return [MTMutablePage class]; }
- (BOOL)handlesSubclasses { return YES; }

- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [library loadPage:xml superclass:type.clazz];
}

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    MTMutablePage* page = (MTMutablePage*)value;
    for (MTProp* prop in page.props) {
        if ([prop isKindOfClass:[MTObjectProp class]]) {
            MTObjectProp* objectProp = (MTObjectProp*)prop;
            if (objectProp.value != nil) {
                id<MTObjectMarshaller> propHandler = [library requireMarshallerForClass:objectProp.valueType.clazz];
                [propHandler withLibrary:library type:objectProp.valueType resolveRefs:objectProp.value];
            }
        }
    }
}

@end

@implementation MTPageRefMarshaller

- (Class)valueType { return [MTMutablePageRef class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [[MTMutablePageRef alloc] initWithPageType:type.subtype.clazz pageName:xml.stringValue];
}

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    MTMutablePageRef* ref = (MTMutablePageRef*)value;
    ref.page = [library requirePageWithQualifiedName:ref.pageName pageClass:ref.pageType];
}

@end

@implementation MTTomeMarshaller

- (Class)valueType { return [MTMutableTome class]; }

- (id)withLibrary:(MTLibrary*)library type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)tomeXml {
    return [library loadTome:tomeXml pageType:type.subtype.clazz];
}

- (void)withLibrary:(MTLibrary*)library type:(MTType*)type resolveRefs:(id)value {
    MTMutableTome* tome = (MTMutableTome*)value;
    id<MTObjectMarshaller> pageHandler = [library requireMarshallerForClass:tome.pageType];
    for (id<MTPage> page in tome.pages) {
        [pageHandler withLibrary:library type:type.subtype resolveRefs:page];
    }
}

@end