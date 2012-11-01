//
// microtome - Copyright 2012 Three Rings Design

#import "MTPage.h"

@interface MTMutablePage : NSObject <MTPage> {
@protected
    NSString* _name;
}

@property (nonatomic,strong) NSString* name;
@end
