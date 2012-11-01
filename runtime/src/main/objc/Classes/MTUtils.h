//
// microtome - Copyright 2012 Three Rings Design

@class MTProp;
@protocol MTPage;

BOOL MTValidLibraryItemName (NSString* name);
MTProp* MTGetProp (id<MTPage> page, NSString* name);

/// Returns the float represented by the string.
/// Throws an exception if the string cannot be converted to a float, or contains extra characters.
float MTRequireFloatValue (NSString* string);

/// Returns the int represented by the string.
/// Throws an exception if the string cannot be converted to a int, or contains extra characters.
int MTRequireIntValue (NSString* string);

/// Returns the BOOL represented by the string.
/// Any capitalization of "true", "yes", "false", or "no" will be converted.
/// Throws an exception if the string cannot be converted to a BOOL, or contains extra characters.
BOOL MTRequireBoolValue (NSString* string);


