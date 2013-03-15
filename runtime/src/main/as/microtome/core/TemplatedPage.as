//
// microtome

package microtome.core {

import microtome.MutablePage;

public class TemplatedPage
{
    public function TemplatedPage (page :MutablePage, data :DataElement) {
        _page = page;
        _data = DataReader.withData(data);
    }

    public function get page () :MutablePage {
        return _page;
    }

    public function get data () :DataReader {
        return _data;
    }

    public function get templateName () :String {
        return _data.requireAttribute(Defs.TEMPLATE_ATTR);
    }

    protected var _page :MutablePage;
    protected var _data :DataReader;
}

}
