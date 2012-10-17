//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLoader.h"

#import "MTUtils.h"
#import "MTType.h"
#import "MTLibrary.h"
#import "MTXmlObjectMarshaller.h"
#import "MTTome.h"
#import "MTPage.h"
#import "MTPageRef.h"
#import "MTProp.h"
#import "MTXmlLoadException.h"

@interface MTStringMarshaller : NSObject <MTXmlObjectMarshaller>
@end

@interface MTEnumMarshaller : NSObject<MTXmlObjectMarshaller>
@end

@interface MTListMarshaller : NSObject <MTXmlObjectMarshaller>
@end

@interface MTPageMarshaller : NSObject <MTXmlObjectMarshaller>
@end

@interface MTPageRefMarshaller : NSObject <MTXmlObjectMarshaller>
@end

@interface MTTomeMarshaller : NSObject <MTXmlObjectMarshaller>
@end

@implementation MTXmlLoader

- (id)init {
    if ((self = [super init])) {
        _marshallers = [[NSMutableDictionary alloc] init];
        [self registerObjectMarshaller:[[MTStringMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTEnumMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTListMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTPageMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTPageRefMarshaller alloc] init]];
        [self registerObjectMarshaller:[[MTTomeMarshaller alloc] init]];
    }
    return self;
}

- (void)registerObjectMarshaller:(id<MTXmlObjectMarshaller>)marshaller {
    _marshallers[(id<NSCopying>)marshaller.objectType] = marshaller;
}

- (id<MTXmlObjectMarshaller>)requireObjectMarshallerForClass:(Class)requiredClass {
    id<MTXmlObjectMarshaller> marshaller = _marshallers[requiredClass];
    if (marshaller == nil) {
        // if we can't find an exact match, see if any of our marshallers handle
        for (id<MTXmlObjectMarshaller> candidate in _marshallers.objectEnumerator) {
            if (candidate.handlesSubclasses && [requiredClass isSubclassOfClass:candidate.objectType]) {
                _marshallers[(id<NSCopying>)requiredClass] = candidate;
                marshaller = candidate;
                break;
            }
        }
    }

    if (marshaller == nil) {
        [NSException raise:NSGenericException format:@"No marshaller for '%@'", requiredClass];
    }

    return marshaller;
}

- (MTMutablePage*)withLibrary:(MTLibrary*)library loadPage:(id)data {
    NSAssert(_library == nil, @"Already loading");
    NSAssert(library != nil, @"Library cannot be nil");
    NSAssert([data isKindOfClass:[GDataXMLDocument class]], @"data must be a GDataXmlDocument");
    
    @try {
        _library = library;
        return [self loadPage:((GDataXMLDocument*)data).rootElement];
    } @finally {
        _library = nil;
    }
}

- (MTMutablePage*)loadPage:(GDataXMLElement*)pageXml requiredClass:(__unsafe_unretained Class)requiredClass {
    NSString* name = pageXml.name;
    if (!MTValidPageName(name)) {
        @throw [MTXmlLoadException withElement:pageXml reason:@"page name '%@' is invalid", name];
    }

    NSString* typeName = [pageXml stringAttribute:@"type"];
    Class pageClass = (requiredClass != nil ?
                       [_library requirePageClassWithName:typeName superClass:requiredClass] :
                       [_library requirePageClassWithName:typeName]);

    MTMutablePage* page = [[pageClass alloc] init];
    page.name = name;
    
    for (MTProp* prop in page.props) {
        MTObjectProp* objectProp =
            ([prop isKindOfClass:[MTObjectProp class]] ? (MTObjectProp*)prop : nil);
        BOOL isPrimitive = (objectProp == nil);
        
        GDataXMLElement* propXml = [pageXml getChild:prop.name];
        if (propXml == nil) {
            if (isPrimitive || !objectProp.nullable) {
                @throw [MTXmlLoadException withElement:pageXml
                            reason:@"Missing required child [name=%@]", prop.name];
            } else {
                // Object is nullable.
                objectProp.value = nil;
            }
            continue;
        }

        @try {
            if (isPrimitive) {
                // Handle primitive props
                if ([prop isKindOfClass:[MTIntProp class]]) {
                    ((MTIntProp*)prop).value = [[self requireTextContent:propXml] requireIntValue];
                } else if ([prop isKindOfClass:[MTBoolProp class]]) {
                    ((MTBoolProp*)prop).value = [[self requireTextContent:propXml] requireBoolValue];
                } else if ([prop isKindOfClass:[MTFloatProp class]]) {
                    ((MTFloatProp*)prop).value = [[self requireTextContent:propXml] requireFloatValue];
                } else {
                    @throw [MTXmlLoadException withElement:propXml
                                reason:@"Unrecognized primitive prop [name=%@, class=%@]",
                                prop.name, [prop class]];
                }

            } else {
                // Handle object props
                id<MTXmlObjectMarshaller> marshaller =
                    [self requireObjectMarshallerForClass:objectProp.valueType.clazz];
                id value = [marshaller withCtx:self type:objectProp.valueType loadObjectfromXml:propXml];
                objectProp.value = value;
            }
        } @catch (MTXmlLoadException* e) {
            @throw e;
        } @catch (NSException* e) {
            @throw [MTXmlLoadException withElement:propXml reason:@"Error loading prop '%@': %@",
                    prop.name, e.reason];
        }
    }
    return page;
}

- (id<MTPage>)loadPage:(GDataXMLElement*)xml {
    return [self loadPage:xml requiredClass:nil];
}

- (NSString*)requireTextContent:(GDataXMLElement*)xml {
    NSString* str = xml.stringValue;
    if (str == nil) {
        @throw [MTXmlLoadException withElement:xml reason:@"Element is empty"];
    }
    return str;
}

@end


@implementation MTStringMarshaller

- (BOOL)handlesSubclasses {
    return NO;
}

- (Class)objectType {
    return [NSString class];
}

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSString* val = xml.stringValue;
    // handle the empty string (<myStringProp></myStringProp>)
    if (val == nil) {
        val = @"";
    }
    return val;
}

@end


@implementation MTEnumMarshaller

- (BOOL)handlesSubclasses {
    return YES;
}

- (Class)objectType {
    return [OOOEnum class];
}

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [type.clazz valueOf:xml.stringValue];
}

@end

@implementation MTListMarshaller

- (BOOL)handlesSubclasses {
    return NO;
}

- (Class)objectType {
    return [NSArray class];
}

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (GDataXMLElement* childXml in xml.elements) {
        id<MTXmlObjectMarshaller> marshaller = [ctx requireObjectMarshallerForClass:type.subtype.clazz];
        id child = [marshaller withCtx:ctx type:type.subtype loadObjectfromXml:childXml];
        [list addObject:child];
    }

    return list;
}

@end


@implementation MTPageMarshaller

- (BOOL)handlesSubclasses {
    return YES;
}

- (Class)objectType {
    return [MTMutablePage class];
}

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [ctx loadPage:xml requiredClass:type.subtype.clazz];
}

@end


@implementation MTPageRefMarshaller

- (BOOL)handlesSubclasses {
    return NO;
}

- (Class)objectType {
    return [MTMutablePageRef class];
}

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [[MTMutablePageRef alloc] initWithPageType:type.subtype.clazz pageName:xml.stringValue];
}

@end


@implementation MTTomeMarshaller

- (BOOL)handlesSubclasses {
    return NO;
}

- (Class)objectType {
    return [MTMutableTome class];
}

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)tomeXml {
    MTMutableTome* tome = [[MTMutableTome alloc] initWithPageType:type.subtype.clazz];
    for (GDataXMLElement* pageXml in tomeXml.elements) {
        id<MTPage> page = [ctx loadPage:pageXml requiredClass:tome.pageType];
        [tome addPage:page];
    }
    return tome;
}

@end

