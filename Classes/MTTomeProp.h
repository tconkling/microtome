//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"

#import "MTTome.h"

@protocol MTTomeProp <MTObjectProp>
@property (nonatomic,readonly) id<MTTome> value;
@property (nonatomic,readonly) Class pageType;
@end


@interface MTMutableTomeProp : MTObjectPropBase <MTTomeProp> {
@protected
    Class _pageType;
    MTMutableTome* _tome;
}

@property (nonatomic,strong) MTMutableTome* value;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType;

@end