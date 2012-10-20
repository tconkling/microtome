//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlObjectMarshaller.h"

#import "MTXmlLoader.h"
#import "MTLibrary.h"
#import "MTType.h"
#import "MTProp.h"
#import "MTMutablePage.h"
#import "MTMutablePageRef.h"
#import "MTMutableTome.h"

@implementation MTStringMarshaller

- (id)withLoader:(MTLibrary*)loader type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSString* val = xml.stringValue;
    // handle the empty string (<myStringProp></myStringProp>)
    if (val == nil) {
        val = @"";
    }
    return val;
}

@end

@implementation MTListMarshaller

- (id)withLoader:(MTXmlLoader*)loader type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (GDataXMLElement* childXml in xml.elements) {
        id<MTXmlObjectMarshaller> marshaller = [loader requireObjectMarshallerForClass:type.subtype.clazz];
        id child = [marshaller withLoader:loader type:type.subtype loadObjectfromXml:childXml];
        [list addObject:child];
    }

    return list;
}

@end


@implementation MTPageMarshaller

- (id)withLoader:(MTXmlLoader*)loader type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [loader loadPage:xml superclass:type.clazz];
}

@end


@implementation MTPageRefMarshaller

- (id)withLoader:(MTXmlLoader*)loader type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)xml {
    return [[MTMutablePageRef alloc] initWithPageType:type.subtype.clazz pageName:xml.stringValue];
}

@end


@implementation MTTomeMarshaller

- (id)withLoader:(MTXmlLoader*)loader type:(MTType*)type loadObjectfromXml:(GDataXMLElement*)tomeXml {
    return [loader loadTome:tomeXml pageType:type.subtype.clazz];
}

@end