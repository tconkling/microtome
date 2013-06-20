
#import "MicrotomePages.h"
#import "AnnotationPage.h"
#import "ListPage.h"
#import "NestedPage.h"
#import "ObjectPage.h"
#import "PrimitiveListPage.h"
#import "PrimitivePage.h"
#import "RefPage.h"

NSArray* GetMicrotomePageClasses (void) {
    return @[
        [AnnotationPage class],
        [ListPage class],
        [NestedPage class],
        [ObjectPage class],
        [PrimitiveListPage class],
        [PrimitivePage class],
        [RefPage class],
    ];
}
