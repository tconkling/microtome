//
// microtome

package microtome {

import flash.utils.Dictionary;

public class Library
{
    public var primitiveMarshaller :PrimitiveMarshaller = new DefaultPrimitiveMarshaller();

    public function Library () {
    }

    public function loadData (dataElements :Array) :void {
        if (_loadTask != null) {
            throw new Error("Load already in progress");
        }
        _loadTask = new LoadTask();

        try {
            for each (var doc :DataElement in dataElements) {

            }
        } catch (e :Error) {
            // TODO
        }
    }

    public function registerPageClasses (...classes) :void {
        for each (var clazz :Class in classes) {
            if (!(clazz is Page)) {
                throw new Error("Class must implement " + Util.getClassName(Page) +
                    " [pageClass=" + Util.getClassName(clazz) + "]");
            }

            _pageClasses[Util.tinyClassName(clazz)] = clazz;
        }
    }

    public function registerObjectMarshaller (marshaller :ObjectMarshaller) :void {
        _objectMarshallers[marshaller.valueType] = marshaller;
    }

    protected var _loadTask :LoadTask;

    protected var _items :Dictionary = new Dictionary();
    protected var _pageClasses :Dictionary = new Dictionary();  // <String, Class>
    protected var _objectMarshallers :Dictionary = new Dictionary(); // <Class, ObjectMarshaller>
}
}
