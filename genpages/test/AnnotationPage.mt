#
# microtome - Tim Conkling, 2012

namespace microtome.test;

AnnotationPage {
    int foo (min=3, max=5);
    int bar (default=3);
    PrimitivePage primitives (nullable);
}
