#include "emscripten/bind.h"
#include "MyClass.h"

using namespace emscripten;

EMSCRIPTEN_BINDINGS(CLASS_MyClass) {
    class_<MyClass>("MyClass")

        .constructor()

        .function("multiply",
                  &MyClass::multiply)

        .function("sayHello",
                  &MyClass::sayHello)

        .function("getDefaultRubberbandEngineVersion",
                  &MyClass::getDefaultRubberbandEngineVersion);
}