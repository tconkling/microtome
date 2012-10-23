//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLibrary.h"

@implementation MTXmlLibrary

- (void)loadFiles:(NSArray*)filenames {
    NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:filenames.count];
    for (NSString* filename in filenames) {
        NSData* filedata = [NSData dataWithContentsOfFile:filename];
        if (filedata == nil) {
            [NSException raise:NSGenericException format:@"Unable to load file '%@'", filename];
        }

        NSError* err;
        GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:filedata options:0 error:&err];
        if (doc == nil) {
            @throw [[NSException alloc] initWithName:NSGenericException
                                              reason:[err localizedDescription]
                                            userInfo:[err userInfo]];
        }
        [data addObject:doc.rootElement];
    }

    [self loadData:data];
}

- (void)loadXmlDocs:(NSArray*)docs {
    NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:docs.count];
    for (GDataXMLDocument* doc in docs) {
        [data addObject:doc.rootElement];
    }

    [self loadData:data];
}

@end
