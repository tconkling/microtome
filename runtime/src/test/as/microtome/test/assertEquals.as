//
// microtome-test

package microtome.test {

public function assertEquals (a :*, b :*, failureMessage :String="") :void {
    if (a != b) {
        throw new Error(failureMessage);
    }
}

}
