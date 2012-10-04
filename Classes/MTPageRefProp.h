//
// microtome - Copyright 2012 Three Rings Design

#import "MTPropBase.h"
#import "MTPageRef.h"

@protocol MTPageRefProp <MTObjectProp>
@property (nonatomic,readonly) Class pageType;
@end

@interface MTMutablePageRefProp : MTObjectPropBase <MTPageRefProp> {
@protected
    Class _pageType;
}

- (id)initWithName:(NSString*)name nullable:(BOOL)nullable pageType:(Class)pageType;

@end
