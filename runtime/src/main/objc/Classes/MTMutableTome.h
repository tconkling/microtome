//
// microtome - Copyright 2012 Three Rings Design

#import "MTTome.h"

@interface MTMutableTome : NSObject <MTTome> {
@protected
    NSString* _name;
    MTTypeInfo* _typeInfo;
    NSMutableDictionary* _pages;
}

- (id)initWithName:(NSString*)name pageClass:(Class)pageClass;

- (void)addPage:(MTPage*)page;

@end