//
// microtome

package microtome.core {

import microtome.MutableTome;

public class TemplatedTome
{
    public function TemplatedTome (tome :MutableTome, reader :DataReader) {
        _tome = tome;
        _reader = reader;
    }

    public function get tome () :MutableTome {
        return _tome;
    }

    public function get reader () :DataReader {
        return _reader;
    }

    public function get templateName () :String {
        return _reader.requireString(Defs.TEMPLATE_ATTR);
    }

    protected var _tome :MutableTome;
    protected var _reader :DataReader;
}

}
