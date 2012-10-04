//
// microtome - Copyright 2012 Three Rings Design

#import "microtomeTests.h"

#import "MTSimpleTestPage.h"

static const float EPSILON = 0.0001f;

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
    NSError* err = nil;
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString:MTSimpleTestPage.XML options:0 error:&err];

    MTSimpleTestPage* page = [_xmlCtx load:doc];
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");
}

@end
