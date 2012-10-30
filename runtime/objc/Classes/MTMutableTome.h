//
// microtome - Copyright 2012 Three Rings Design

#import "MTTome.h"

@interface MTMutableTome : NSObject <MTTome> {
@protected
    NSString* _name;
    MTTypeInfo* _type;
    NSMutableDictionary* _pages;
}

- (id)initWithName:(NSString*)name pageType:(Class)pageType;

- (void)addPage:(id<MTPage>)page;

@end