//
// microtome - Copyright 2012 Three Rings Design

#import "GDataXMLNode.h"

@interface GDataXMLElement (MTExtensions)

- (NSArray*)elements; // returns all child elements

- (BOOL)hasChild:(NSString*)name;
- (BOOL)hasAttribute:(NSString*)name;

- (NSString*)getAttr:(NSString*)name required:(BOOL)required;
- (NSString*)stringAttribute:(NSString*)name defaultVal:(NSString*)defaultVal required:(BOOL)required;
- (NSString*)stringAttribute:(NSString*)name defaultVal:(NSString*)defaultVal;
- (NSString*)stringAttribute:(NSString*)name;
- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal required:(BOOL)required;
- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal;
- (float)floatAttribute:(NSString*)name;
- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal required:(BOOL)required;
- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal;
- (int)intAttribute:(NSString*)name;
- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal required:(BOOL)required;
- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal;
- (BOOL)boolAttribute:(NSString*)name;

- (GDataXMLElement*)requireSingleChild;
- (GDataXMLElement*)requireChild:(NSString*)path;
- (GDataXMLElement*)getChild:(NSString*)path;

@end
