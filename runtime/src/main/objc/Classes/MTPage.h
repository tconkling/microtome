//
// microtome - Copyright 2012 Three Rings Design

#import "MTLibraryItem.h"

@interface MTPage : NSObject <MTLibraryItem> {
@protected
    NSString* _name;
}

@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) NSArray* props;

@end

#define MT_PROPS(...) ({ [super.props arrayByAddingObjectsFromArray:@[ __VA_ARGS__ ]]; })

