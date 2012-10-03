//
// microtome - Copyright 2012 Three Rings Design

@protocol MTNamedPage;

@protocol MTTome <NSObject>
@property (nonatomic,readonly) Class pageClass;
@property (nonatomic,readonly) int count;

- (id<MTNamedPage>)pageNamed:(NSString*)name;
- (id<MTNamedPage>)requirePageNamed:(NSString*)name;
@end