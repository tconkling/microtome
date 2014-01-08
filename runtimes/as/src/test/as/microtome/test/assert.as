//
// microtome-test

package microtome.test {

public function assert (condition :Boolean, failureMessage :String="") :void {
    if (!condition) {
        throw new Error(failureMessage);
    }
}

}
