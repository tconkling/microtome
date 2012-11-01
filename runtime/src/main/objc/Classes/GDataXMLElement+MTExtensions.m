//
// microtome - Copyright 2012 Three Rings Design

#import "GDataXMLElement+MTExtensions.h"

#import "MTDefs.h"

@implementation GDataXMLElement (MTExtensions)

@dynamic name;
@dynamic description;

- (NSString*)value {
    return self.stringValue;
}

- (NSString*)attributeNamed:(NSString*)name {
    GDataXMLNode* attr = [self attributeForName:name];
    return (attr != nil ? attr.stringValue : nil);
}

- (void)loadChildrenIntoArray:(NSMutableArray*)array {
    for (GDataXMLNode* child in [self children]) {
        if ([child kind] == GDataXMLElementKind) {
            [array addObject:child];
        }
    }
}

@end
