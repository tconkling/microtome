//
// microtome - Copyright 2012 Three Rings Design

#import "MTDataElement.h"

#import "MTLoadException.h"
#import "MTUtils.h"

@implementation MTDataReader {
@protected
    id<MTDataElement> _data;
    NSMutableArray* _children;
    NSMutableDictionary* _childrenByName;
}

+ (MTDataReader*)withData:(id<MTDataElement>)data {
    if ([data isKindOfClass:[MTDataReader class]]) {
        return (MTDataReader*)data;
    } else {
        return [[MTDataReader alloc] initWithData:data];
    }
}

- (id)initWithData:(id<MTDataElement>)data {
    if ((self = [super init])) {
        _data = data;
    }
    return self;
}

- (NSString*)name {
    return _data.name;
}

- (NSString*)value {
    return _data.value;
}

- (NSString*)description {
    return _data.description;
}

- (void)loadChildrenIntoArray:(NSMutableArray*)array {
    [_data loadChildrenIntoArray:array];
}

- (NSString*)attributeNamed:(NSString*)name {
    return [_data attributeNamed:name];
}

- (NSArray*)children {
    if (_children == nil) {
        _children = [[NSMutableArray alloc] init];
        [_data loadChildrenIntoArray:_children];
    }
    return _children;
}

- (BOOL)hasChild:(NSString*)name {
    return [self childNamed:name] != nil;
}

- (id<MTDataElement>)childNamed:(NSString*)name {
    if (_childrenByName == nil) {
        _childrenByName = [[NSMutableDictionary alloc] initWithCapacity:MIN(self.children.count, 1)];
        for (id<MTDataElement> child in self.children) {
            _childrenByName[child.name] = child;
        }
    }

    return _childrenByName[name];
}

- (NSString*)requireValue {
    NSString* val = _data.value;
    if (val == nil) {
        @throw [MTLoadException withData:_data reason:@"Element is empty"];
    }
    return val;
}

- (BOOL)hasAttribute:(NSString*)name {
    return [_data attributeNamed:name] != nil;
}

- (NSString*)requireAttribute:(NSString*)name {
    NSString* attr = [_data attributeNamed:name];
    if (attr == nil) {
        @throw [MTLoadException withData:_data reason:@"Missing required attribute '%@'", name];
    }
    return attr;
}

- (BOOL)requireBoolAttribute:(NSString*)name {
    NSString* attr = [self requireAttribute:name];
    @try {
        return MTRequireBoolValue(attr);
    } @catch (NSException* e) {
        @throw [MTLoadException withData:_data reason:@"Error reading attribute '%@': %@", name,
                e.description];
    }
}

- (int)requireIntAttribute:(NSString*)name {
    NSString* attr = [self requireAttribute:name];
    @try {
        return MTRequireIntValue(attr);
    } @catch (NSException* e) {
        @throw [MTLoadException withData:_data reason:@"Error reading attribute '%@': %@", name,
                e.description];
    }
}

- (float)requireFloatAttribute:(NSString*)name {
    NSString* attr = [self requireAttribute:name];
    @try {
        return MTRequireFloatValue(attr);
    } @catch (NSException* e) {
        @throw [MTLoadException withData:_data reason:@"Error reading attribute '%@': %@", name,
                e.description];
    }
}

@end
