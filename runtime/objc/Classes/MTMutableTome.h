//
// microtome - Copyright 2012 Three Rings Design

#import "MTTome.h"

@interface MTMutableTome : NSObject <MTTome> {
@protected
    NSString* _name;
    MTTypeInfo* _type;
    NSMutableDictionary* _pages;
}

- (id)initWithName:(NSString*)name pageClass:(Class)pageClass;

- (void)addPage:(id<MTPage>)page;

@end