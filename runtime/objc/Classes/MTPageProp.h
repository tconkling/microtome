//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

@protocol MTPageProp <MTObjectProp>
@property (nonatomic,readonly) Class pageType;
@end

@interface MTMutablePageProp : MTObjectPropBase <MTPageProp> {
@protected
    Class _pageType;
}

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable pageType:(Class)pageType;

@end
