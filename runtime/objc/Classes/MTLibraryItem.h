//
// microtome - Copyright 2012 Three Rings Design

@class MTType;

@protocol MTLibraryItem <NSObject>
@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) MTType* type;
- (id)childNamed:(NSString*)name;
@end
