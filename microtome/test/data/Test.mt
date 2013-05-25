//
// microtome - Tim Conkling, 2012

namespace microtome.test;

PrimitivePage {
    bool foo;
    int bar;
    float baz;
}

ObjectPage {
    string foo;
}

AnnotationPage {
    int foo (min=3, max=5);
    int bar (default=3);
    PrimitivePage primitives (nullable);
}

ListPage {
    List<PrimitivePage> kids;
}

NestedPage {
    PrimitivePage nested;
}

RefPage {
    PageRef<PrimitivePage> nested;
}
