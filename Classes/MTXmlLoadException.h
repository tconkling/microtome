//
// microtome - Copyright 2012 Three Rings Design

#import "MTLoadException.h"

@class GDataXMLElement;

@interface MTXmlLoadException : MTLoadException

+ (MTXmlLoadException*)withReason:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);
+ (MTXmlLoadException*)withElement:(GDataXMLElement*)badElement reason:(NSString*)format, ... NS_FORMAT_FUNCTION(2, 3);
- (id)initWithReason:(NSString*)reason;

@end
