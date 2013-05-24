//
// microtome - Copyright 2012 Three Rings Design

#import "MTUtils.h"

#import "MTDefs.h"
#import "MTLibrary.h"
#import "MTTome.h"
#import "MTPage.h"
#import "MTProp.h"

BOOL MTValidLibraryItemName (NSString* name) {
    return [name rangeOfString:MT_NAME_SEPARATOR].location == NSNotFound;
}

MTProp* MTGetProp (MTPage* page, NSString* name) {
    for (MTProp* prop in page.props) {
        if ([prop.name isEqualToString:name]) {
            return prop;
        }
    }
    return nil;
}

float MTRequireFloatValue (NSString* string) {
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    float retVal;
    if (![scanner scanFloat:&retVal] || !scanner.isAtEnd) {
        [NSException raise:NSGenericException format:@"'%@' could not be converted to a float", string];
    }

    return retVal;
}

int MTRequireIntValue (NSString* string) {
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    int retVal;
    if (![scanner scanInt:&retVal] || !scanner.isAtEnd) {
        [NSException raise:NSGenericException format:@"'%@' could not be converted to a int", string];
    }

    return retVal;
}

BOOL MTRequireBoolValue (NSString* string) {
    NSString* lowercase = [string lowercaseString];
    if ([lowercase isEqualToString:@"true"] || [lowercase isEqualToString:@"yes"]) {
        return YES;
    } else if ([lowercase isEqualToString:@"false"] || [lowercase isEqualToString:@"no"]) {
        return NO;
    } else {
        [NSException raise:NSGenericException format:@"'%@' could not be converted to a BOOL", string];
    }

    return NO;
}