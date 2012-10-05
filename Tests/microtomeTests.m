//
// microtome - Copyright 2012 Three Rings Design

#import "microtomeTests.h"

#import "PrimitivePage.h"
#import "NamedPage.h"
#import "TomePage.h"
#import "NestedPage.h"

static const float EPSILON = 0.0001f;

@implementation microtomeTests

- (void)setUp {
    [super setUp];
    _xmlCtx = [[MTXmlContext alloc] init];
    [_xmlCtx registerPageClass:[PrimitivePage class]];
    [_xmlCtx registerPageClass:[NamedPage class]];
    [_xmlCtx registerPageClass:[TomePage class]];
    [_xmlCtx registerPageClass:[NestedPage class]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPrimitives {
    NSError* err = nil;
    GDataXMLDocument* doc =
        [[GDataXMLDocument alloc] initWithXMLString:PrimitivePage.XML options:0 error:&err];

    PrimitivePage* page = [_xmlCtx load:doc];
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");
}

- (void)testTome {
    NSError* err = nil;
    GDataXMLDocument* doc =
        [[GDataXMLDocument alloc] initWithXMLString:TomePage.XML options:0 error:&err];

    TomePage* page = [_xmlCtx load:doc];
    STAssertEquals(page.tome.count, 2, @"");
}

- (void)testNested {
    NSError* err = nil;
    GDataXMLDocument* doc =
    [[GDataXMLDocument alloc] initWithXMLString:NestedPage.XML options:0 error:&err];

    NestedPage* page = [_xmlCtx load:doc];
    STAssertEquals(page.nested.foo, YES, @"");
    STAssertEquals(page.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.nested.baz, 3.1415f, EPSILON, @"");
}

@end
