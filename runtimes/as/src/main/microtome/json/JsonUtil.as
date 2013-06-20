package microtome.json {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;

public class JsonUtil {
    /** Creates ReadableObjects from a Vector of JSON objects */
    public static function createReaders (jsons :Vector.<Object>) :Vector.<ReadableObject> {
        const data :Vector.<ReadableObject> = new <ReadableObject>[];
        for each (var json :Object in jsons) {
            data.push(new JsonObject("microtome", json));
        }
        return data;
    }

    public static function createWriter (name :String, json :Object) :WritableObject {
        return new JsonObject(name, json);
    }
}
}
