//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

#import "MTTome.h"

@protocol MTTomeProp <MTObjectProp>
@property (nonatomic,readonly) Class pageType;
@end


@interface MTMutableTomeProp : MTObjectPropBase <MTTomeProp> {
@protected
    Class _pageType;
}

- (id)initWithName:(NSString*)name parent:(id<MTPage>)parent nullable:(BOOL)nullable pageType:(Class)pageType;

@end