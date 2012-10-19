//
// microtome - Copyright 2012 Three Rings Design

@protocol MTPageRef <NSObject>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) NSString* pageName;
@property (nonatomic,readonly) id page;
@end