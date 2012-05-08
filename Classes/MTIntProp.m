//
// microtome - Copyright 2012 Three Rings Design

#import "MTIntProp.h"

@implementation MTIntProp

- (id)initWithName:(NSString*)name 
        hasDefault:(BOOL)hasDefault 
        defaultVal:(int)defaultVal
               min:(int)min 
               max:(int)max {
    if ((self = [super initWithName:name hasDefault:hasDefault])) {
        _min = min;
        _max = max;
        _default = defaultVal;
    }
    return self;
}

- (id)fromXml:(GDataXMLElement*)xml {
    int value = [xml intAttribute:_name defaultVal:_default required:!_hasDefault];
    if (value < _min || value > _max) {
        @throw [GDataXMLException withElement:xml 
                                       reason:@"value out of range [min=%d,max=%d]", _min, _max];
    }
    
    return [OOOBoxedInt withValue:value];
}

@end
