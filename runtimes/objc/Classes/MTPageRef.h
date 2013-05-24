//
// microtome - Copyright 2012 Three Rings Design

@interface MTPageRef : NSObject {
@protected
    Class _pageClass;
    NSString* _pageName;
    __weak id _page;
}

@property (nonatomic,readonly) Class pageClass;
@property (nonatomic,readonly) NSString* pageName;
@property (nonatomic,weak) id page;

- (id)initWithPageClass:(Class)pageClass pageName:(NSString*)pageName;

@end