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
    _library = [[MTLibrary alloc] initWithLoader:[[MTXmlLoader alloc] init]];
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
    PrimitivePage* page = [_library loadData:GetXML(PrimitivePage.XML)];
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");
    [_library unloadDataWithName:page.name];
}

- (void)testTome {
    TomePage* page = [_library loadData:GetXML(TomePage.XML)];
    STAssertEquals(page.tome.pageCount, 2, @"");
    [_library unloadDataWithName:page.name];
}

- (void)testNested {
    NestedPage* page = [_library loadData:GetXML(NestedPage.XML)];
    STAssertEquals(page.nested.foo, YES, @"");
    STAssertEquals(page.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.nested.baz, 3.1415f, EPSILON, @"");
    [_library unloadDataWithName:page.name];
}

- (void)testRefs {
    RefPage* refPage = nil;
    @autoreleasepool {
        TomePage* tomePage = [_library loadData:GetXML(TomePage.XML)];
        refPage = [_library loadData:GetXML(RefPage.XML)];
        STAssertNotNil(refPage.nested, @"");
        STAssertEquals(refPage.nested.foo, YES, @"");
        STAssertEquals(refPage.nested.bar, 2, @"");
        STAssertEqualsWithAccuracy(refPage.nested.baz, 3.1415f, EPSILON, @"");
        [_library unloadDataWithName:tomePage.name];
        tomePage = nil;
    }
    
    STAssertNil(refPage.nested, @"");
    [_library unloadDataWithName:refPage.name];
}

@end
