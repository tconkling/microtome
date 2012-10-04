//
// microtome - Copyright 2012 Three Rings Design

@protocol MTPage <NSObject>
@property (nonatomic,readonly) NSArray* props;
@end

@protocol MTNamedPage <MTPage>
@property (nonatomic,readonly) NSString* name;
@end

@interface MTMutablePage : NSObject <MTPage> {
@protected
    NSArray* _props;
}
- (id)initWithProps:(NSArray*)props;
@end

@interface MTMutableNamedPage : MTMutablePage <MTNamedPage> {
@protected
    NSString* _name;
}
@property (nonatomic,strong) NSString* name;
@end
