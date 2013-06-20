//
// microtome - Tim Conkling, 2012

namespace microtome.test;

page PrimitivePage {
    bool foo;
    int bar;
    float baz;
}

page ObjectPage {
    string foo;
}

page AnnotationPage {
    int foo (min=3, max=5);
    int bar (default=3);
    PrimitivePage primitives (nullable);
}

page ListPage {
    List<PrimitivePage> kids;
}

page NestedPage {
    PrimitivePage nested;
}

page RefPage {
    PageRef<PrimitivePage> nested;
}

page PrimitiveListPage {
    List<string> strings;
    List<bool> booleans;
    List<int> ints;
    List<float> floats;
}
