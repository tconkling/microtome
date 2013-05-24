//
// microtome

package microtome.core {

import microtome.MutablePage;

public class TemplatedPage
{
    public function TemplatedPage (page :MutablePage, reader :DataReader) {
        _page = page;
        _reader = reader;
    }

    public function get page () :MutablePage {
        return _page;
    }

    public function get reader () :DataReader {
        return _reader;
    }

    public function get templateName () :String {
        return _reader.requireString(Defs.TEMPLATE_ATTR);
    }

    protected var _page :MutablePage;
    protected var _reader :DataReader;
}

}
