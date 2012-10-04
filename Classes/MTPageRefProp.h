//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"
#import "MTPageRef.h"

@protocol MTPageRefProp <MTObjectProp>
@property (nonatomic,readonly) Class pageType;
@property (nonatomic,readonly) id<MTPageRef> value;
@end

@interface MTMutablePageRefProp : MTObjectPropBase <MTPageRefProp> {
@protected
    Class _pageType;
    MTMutablePageRef* _ref;
}

@property (nonatomic,strong) MTMutablePageRef* value;

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType;

@end
