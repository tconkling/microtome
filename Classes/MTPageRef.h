//
// microtome - Copyright 2012 Three Rings Design

@protocol MTPageRef <NSObject>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) NSString* pageName;
@property (nonatomic,readonly) id page;
@end

@interface MTMutablePageRef : NSObject <MTPageRef> {
@protected
    Class _pageType;
    NSString* _pageName;
    __weak id _page;
}

@property (nonatomic,weak) id page;

- (id)initWithPageType:(Class)pageType pageName:(NSString*)pageName;

@end