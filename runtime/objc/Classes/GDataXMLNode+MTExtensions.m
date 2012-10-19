//
// microtome - Copyright 2012 Three Rings Design

#import "GDataXMLNode+MTExtensions.h"
#import "MTXmlLoadException.h"
#import "MTUtils.h"

@implementation GDataXMLElement (MTExtensions)

- (NSArray*)elements {
    NSMutableArray* elements = nil;
    for (GDataXMLNode* child in [self children]) {
        if ([child kind] == GDataXMLElementKind) {
            if (elements == nil) {
                elements = [NSMutableArray arrayWithObject:child];
            } else {
                [elements addObject:child];
            }
        }
    }
    return elements;
}

- (NSString*)getAttr:(NSString*)name required:(BOOL)required {
    GDataXMLNode* attr = [self attributeForName:name];
    if (attr == nil && required) {
        @throw [MTXmlLoadException withElement:self reason:@"Missing required attribute '%@'", name];
    }
    return (attr != nil ? [attr stringValue] : nil);
}

- (BOOL)hasChild:(NSString*)name {
    NSArray* children = [self elementsForName:name];
    return (children != nil && children.count > 0);
}

- (BOOL)hasAttribute:(NSString*)name; {
    return [self attributeForName:name] != nil;
}

- (NSString*)stringAttribute:(NSString*)name defaultVal:(NSString*)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    return (attr != nil ? attr : defaultVal);
}

- (NSString*)stringAttribute:(NSString*)name defaultVal:(NSString*)defaultVal {
    return [self stringAttribute:name defaultVal:defaultVal required:NO];
}

- (NSString*)stringAttribute:(NSString*)name {
    return [self stringAttribute:name defaultVal:nil required:YES];
}

- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;

    @try {
        return MTRequireFloatValue(attr);
    } @catch (NSException* e) {
        @throw [MTXmlLoadException withElement:self
                                       reason:@"Error reading attribute '%@': %@", name, e.reason];
    }
}

- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal {
    return [self floatAttribute:name defaultVal:defaultVal required:NO];
}

- (float)floatAttribute:(NSString*)name {
    return [self floatAttribute:name defaultVal:0 required:YES];
}

- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;

    @try {
        return MTRequireIntValue(attr);
    } @catch (NSException* e) {
        @throw [MTXmlLoadException withElement:self
                                       reason:@"Error reading attribute '%@': %@", name, e.reason];
    }
}

- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal {
    return [self intAttribute:name defaultVal:defaultVal required:NO];
}

- (int)intAttribute:(NSString*)name {
    return [self intAttribute:name defaultVal:0 required:YES];
}

- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;

    @try {
        return MTRequireBoolValue(attr);
    } @catch (NSException* e) {
        @throw [MTXmlLoadException withElement:self
                                       reason:@"Error reading attribute '%@': %@", name, e.reason];
    }
}

- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal {
    return [self boolAttribute:name defaultVal:defaultVal required:NO];
}

- (BOOL)boolAttribute:(NSString*)name {
    return [self boolAttribute:name defaultVal:0 required:YES];
}

- (GDataXMLElement*)requireSingleChild {
    NSArray* elements = self.elements;
    if (elements.count != 1) {
        @throw [MTXmlLoadException withElement:self
           reason:@"Expected exactly 1 child element (found %d)", elements.count];
    }
    return elements[0];
}

- (GDataXMLElement*)getChild:(NSString*)path {
    NSArray* els = [NSArray arrayWithObject:self];
    for (NSString* name in [path componentsSeparatedByString:@"/"]) {
        els = [els[0] elementsForName:name];
        if ([els count] > 1 || [els count] == 0) return nil;
    }
    return els[0];
}

- (GDataXMLElement*)requireChild:(NSString*)path {
    GDataXMLElement* current = self;
    for (NSString* name in [path componentsSeparatedByString:@"/"]) {
        NSArray* els = [current elementsForName:name];
        if ([els count] > 1) {
            @throw [MTXmlLoadException withElement:current
                reason:@"More than one child named '%@' in path '%@'", name, path];
        } else if ([els count] == 0) {
            @throw [MTXmlLoadException withElement:current
                reason:@"No child named '%@' in path '%@'", name, path];
        }
        current = els[0];
    }
    return current;
}

@end
