
package microtome.test {

import microtome.test.AnnotationPage;
import microtome.test.ListPage;
import microtome.test.NestedPage;
import microtome.test.PrimitivePage;
import microtome.test.RefPage;

public class MicrotomePages {
    public static function get pageClasses () :Vector.<Class> { return PAGE_CLASSES; }

    protected static const PAGE_CLASSES :Vector.<Class> = new <Class>[
        microtome.test.AnnotationPage,
        microtome.test.ListPage,
        microtome.test.NestedPage,
        microtome.test.PrimitivePage,
        microtome.test.RefPage,
    ];
}

}
