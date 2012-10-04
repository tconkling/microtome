//
// microtome - Copyright 2012 Three Rings Design

#import "microtomeTests.h"

#import "MTSimpleTestPage.h"

@implementation microtomeTests

- (void)setUp {
    [super setUp];
    _xmlCtx = [[MTXmlContext alloc] init];
    [_xmlCtx registerPageClass:[MTSimpleTestPage class]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSimplePage {
    static NSString* const XML =
        @"<MTSimpleTestPage>"
        @"  <foo>3</foo>"
        @"</MTSimpleTestPage>";

    NSError* err = nil;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:XML options:0 error:&err];

    MTSimpleTestPage* page = [_xmlCtx load:doc];
    STAssertEquals(page.foo, 3, @"");
}

@end
