//
// microtome - Copyright 2012 Three Rings Design

@protocol MTDataElement <NSObject>

@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) NSString* value;
@property (nonatomic,readonly) NSString* description;

- (NSString*)attributeNamed:(NSString*)name;

- (void)loadChildrenIntoArray:(NSMutableArray*)array;

@end

@interface MTDataReader : NSObject <MTDataElement>

+ (MTDataReader*)withData:(id<MTDataElement>)data;

- (NSArray*)children;

- (NSString*)requireValue;

- (BOOL)hasChild:(NSString*)name;
- (id<MTDataElement>)childNamed:(NSString*)name;

- (BOOL)hasAttribute:(NSString*)name;

- (NSString*)requireAttribute:(NSString*)name;
- (BOOL)requireBoolAttribute:(NSString*)name;
- (int)requireIntAttribute:(NSString*)name;
- (float)requireFloatAttribute:(NSString*)name;

@end


