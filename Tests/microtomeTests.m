//
// microtome - Copyright 2012 Three Rings Design

#import "microtomeTests.h"

#import "PrimitivePage.h"
#import "TomePage.h"
#import "NestedPage.h"

static const float EPSILON = 0.0001f;

@implementation microtomeTests

- (void)setUp {
    [super setUp];
    _library = [[MTLibrary alloc] initWithLoader:[[MTXmlLoader alloc] init]];
    [_library registerPageClass:[PrimitivePage class]];
    [_library registerPageClass:[TomePage class]];
    [_library registerPageClass:[NestedPage class]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPrimitives {
    static NSString* const NAME = @"Primitive";
    
    NSError* err = nil;
    GDataXMLDocument* doc =
        [[GDataXMLDocument alloc] initWithXMLString:PrimitivePage.XML options:0 error:&err];

    PrimitivePage* page = [_library loadData:doc withName:NAME];
    STAssertEquals(page.foo, YES, @"");
    STAssertEquals(page.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.baz, 3.1415f, EPSILON, @"");
    [_library unloadDataWithName:NAME];
}

- (void)testTome {
    static NSString* const NAME = @"Tome";
    
    NSError* err = nil;
    GDataXMLDocument* doc =
        [[GDataXMLDocument alloc] initWithXMLString:TomePage.XML options:0 error:&err];

    TomePage* page = [_library loadData:doc withName:NAME];
    STAssertEquals(page.tome.pageCount, 2, @"");
    [_library unloadDataWithName:NAME];
}

- (void)testNested {
    static NSString* const NAME = @"Nested";
    
    NSError* err = nil;
    GDataXMLDocument* doc =
        [[GDataXMLDocument alloc] initWithXMLString:NestedPage.XML options:0 error:&err];

    NestedPage* page = [_library loadData:doc withName:NAME];
    STAssertEquals(page.nested.foo, YES, @"");
    STAssertEquals(page.nested.bar, 2, @"");
    STAssertEqualsWithAccuracy(page.nested.baz, 3.1415f, EPSILON, @"");
    [_library unloadDataWithName:NAME];
}

@end
