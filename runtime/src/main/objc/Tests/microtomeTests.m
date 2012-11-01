//
// microtome - Copyright 2012 Three Rings Design

#import "microtomeTests.h"

#import "PrimitivePage.h"
#import "NestedPage.h"
#import "RefPage.h"

static const float EPSILON = 0.0001f;

@implementation microtomeTests

- (NSString*)pathFor:(NSString*)filename {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    filename = [filename lastPathComponent];
    NSString* path = [bundle pathForResource:filename ofType:nil];
    return path;
}

- (void)setUp {
    [super setUp];
    _library = [[MTXmlLibrary alloc] init];
    [_library registerPageClasses:@[
        [PrimitivePage class],
        [NestedPage class],
        [RefPage class],
    ]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPrimitives {
    [_library loadFiles:@[ [self pathFor:@"PrimitiveTest.xml"] ]];
    PrimitivePage* page = _library[@"primitiveTest"];
    STAssertNotNil(page, @"");
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");
    [_library removeAllItems];
}

- (void)testTome {
    [_library loadFiles:@[ [self pathFor:@"TomeTest.xml"] ]];
    id<MTTome> tome = _library[@"tomeTest"];
    STAssertEquals(tome.pageCount, 2, @"");
    [_library removeAllItems];
}

- (void)testNested {
    [_library loadFiles:@[ [self pathFor:@"NestedTest.xml"] ]];
    NestedPage* page = _library[@"nestedTest"];
    STAssertEquals(page.nested.foo, YES, @"");
    STAssertEquals(page.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.nested.baz, 3.1415f, EPSILON, @"");
    [_library removeAllItems];
}

- (void)testRefs {
    [_library loadFiles:@[ [self pathFor:@"TomeTest.xml"], [self pathFor:@"RefTest.xml"] ]];
    RefPage* refPage = _library[@"refTest"];
    STAssertNotNil(refPage.nested, @"");
    STAssertEquals(refPage.nested.foo, YES, @"");
    STAssertEquals(refPage.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(refPage.nested.baz, 3.1415f, EPSILON, @"");
    [_library removeAllItems];
}

- (void)testTemplates {
    [_library loadFiles:@[ [self pathFor:@"TemplateTest.xml"] ]];
    
    PrimitivePage* page = _library[@"test1"];
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");

    page = _library[@"test2"];
    STAssertEqualsWithAccuracy(page.baz, 666.0f, EPSILON, @"");
    
    [_library removeAllItems];
}

@end
