//
// microtome - Copyright 2012 Three Rings Design

/// Creates an NSString from a format string and parameters.
/// - (NSString*)getMyFormatString:(NSString*)format, ... { return MT_FORMAT_TO_NSSTRING(format); }
#define MT_FORMAT_TO_NSSTRING(format) ({ \
    va_list args; \
    va_start(args, format); \
    NSString* string = [[NSString alloc] initWithFormat:format arguments:args]; \
    va_end(args); \
    string; \
    })

/// Throws an exception indicating that the current method is abstract
#define MT_IS_ABSTRACT() ({ \
    [NSException raise:NSInternalInconsistencyException \
    format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]; \
    })


#define MT_NAME_SEPARATOR @"."

#define MT_PAGE_TYPE_ATTR @"pageType"
#define MT_TOME_TYPE_ATTR @"tomeType"
#define MT_TEMPLATE_ATTR @"template"

#define MT_NULLABLE_ANNOTATION @"nullable"
#define MT_MIN_ANNOTATION @"min"
#define MT_MAX_ANNOTATION @"max"
#define MT_DEFAULT_ANNOTATION @"default"
