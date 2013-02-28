//
// microtome

package microtome.core {

import microtome.Page;

public class TemplatedPage
{
    public function TemplatedPage (page :Page, data :DataElement) {
        _page = page;
        _data = DataReader.withData(data);
    }

    public function get page () :Page {
        return _page;
    }

    public function get data () :DataReader {
        return _data;
    }

    public function get templateName () :String {
        return _data.requireAttribute(Defs.TEMPLATE_ATTR);
    }

    protected var _page :Page;
    protected var _data :DataReader;
}

}
