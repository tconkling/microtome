package microtome.json {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;

public class JsonUtil {
    /**
     * Creates Readable objects for each named property of the jsons Object passed in.
     */
    public static function createReaders (jsons :Object) :Vector.<ReadableObject> {
        const data :Vector.<ReadableObject> = new <ReadableObject>[];
        for (var prop in jsons) {
            if (jsons.hasOwnProperty(prop)) {
                data.push(createReader(prop, jsons[prop]));
            }
        }
        return data;
    }

    public static function createReader (name :String, json :Object) :ReadableObject {
        return json is Array ? new JsonArray(name, json as Array) : new JsonObject(name, json);
    }

    public static function createWriter (name :String, json :Object) :WritableObject {
        return new JsonObject(name, json);
    }
}
}
