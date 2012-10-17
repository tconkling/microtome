//
// microtome - Copyright 2012 Three Rings Design

#import "microtomeTests.h"

#import "PrimitivePage.h"
#import "TomePage.h"
#import "NestedPage.h"
#import "RefPage.h"

static const float EPSILON = 0.0001f;

static GDataXMLDocument* GetXML (NSString* xmlString) {
    NSError* err = nil;
    return [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&err];
}

@implementation microtomeTests

- (void)setUp {
    [super setUp];
    _library = [[MTLibrary alloc] init];
    _loader = [[MTXmlLoader alloc] initWithLibrary:_library];
    [_library registerPageClasses:@[
        [PrimitivePage class],
        [TomePage class],
        [NestedPage class],
        [RefPage class],
    ]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPrimitives {
    [_loader loadPagesFromDoc:GetXML(PrimitivePage.XML)];
    PrimitivePage* page = _library[@"primitiveTest"];
    STAssertNotNil(page, @"");
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");
    [_library removeAllPages];
}

- (void)testTome {
    [_loader loadPagesFromDoc:GetXML(TomePage.XML)];
    TomePage* page = _library[@"tomeTest"];
    STAssertEquals(page.tome.pageCount, 2, @"");
    [_library removeAllPages];
}

- (void)testNested {
    [_loader loadPagesFromDoc:GetXML(NestedPage.XML)];
    NestedPage* page = _library[@"nestedTest"];
    STAssertEquals(page.nested.foo, YES, @"");
    STAssertEquals(page.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.nested.baz, 3.1415f, EPSILON, @"");
    [_library removeAllPages];
}

- (void)testRefs {
    [_loader loadPagesFromDocs:@[GetXML(TomePage.XML), GetXML(RefPage.XML)]];
    RefPage* refPage = _library[@"refTest"];
    STAssertNotNil(refPage.nested, @"");
    STAssertEquals(refPage.nested.foo, YES, @"");
    STAssertEquals(refPage.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(refPage.nested.baz, 3.1415f, EPSILON, @"");
    [_library removeAllPages];
}

@end
