//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlObjectMarshaller.h"

#import "MTXmlLoader.h"
#import "MTLibrary.h"
#import "MTType.h"
#import "MTProp.h"
#import "MTPage.h"
#import "MTPageRef.h"
#import "MTTome.h"


@implementation MTStringMarshaller

- (id)withCtx:(MTLibrary*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSString* val = xml.stringValue;
    // handle the empty string (<myStringProp></myStringProp>)
    if (val == nil) {
        val = @"";
    }
    return val;
}

@end

@implementation MTListMarshaller

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

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [ctx loadPage:xml superclass:type.clazz];
}

@end


@implementation MTPageRefMarshaller

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [[MTMutablePageRef alloc] initWithPageType:type.subtype.clazz pageName:xml.stringValue];
}

@end


@implementation MTTomeMarshaller

- (id)withCtx:(MTXmlLoader*)ctx type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)tomeXml {
    return [ctx loadTome:tomeXml pageType:type.subtype.clazz];
}

@end