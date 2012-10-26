//
// microtome - Copyright 2012 Three Rings Design

#import "MTXmlLibrary.h"
#import "GDataXMLElement+MTExtensions.h"

@implementation MTXmlLibrary

- (void)loadFiles:(NSArray*)filenames {
    NSMutableArray* docs = [[NSMutableArray alloc] initWithCapacity:filenames.count];
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
        [docs addObject:doc];
    }

    // We need all the GDataXmlDocuments to be in scope while loading occurs,
    // because GDataXmlDocument.dealloc deletes all the XML data which trashes any
    // outstanding elements that we're still using.
    // So instead of just passing a set of rootElements directly to loadData:,
    // we pass our documents to loadXmlDocs, so that are docs are retained throughout
    // the loading process.
    [self loadXmlDocs:docs];
}

- (void)loadXmlDocs:(NSArray*)docs {
    NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:docs.count];
    for (GDataXMLDocument* doc in docs) {
        [data addObject:doc.rootElement];
    }

    [self loadData:data];
}

@end
