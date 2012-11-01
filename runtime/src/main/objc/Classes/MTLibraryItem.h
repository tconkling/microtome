//
// microtome - Copyright 2012 Three Rings Design

@class MTTypeInfo;

@protocol MTLibraryItem <NSObject>
@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) MTTypeInfo* type;
- (id)childNamed:(NSString*)name;
@end
