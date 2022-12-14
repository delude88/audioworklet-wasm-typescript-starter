//
// Created by Tobias Hegemann on 26.09.22.
//

#include "MyClass.h"
MyClass::MyClass() {

}
float MyClass::multiply(float a, float b) {
  return a * b;
}
std::string MyClass::sayHello(std::string name) {
  return "Hello " + name;
}
int MyClass::getDefaultRubberbandEngineVersion() {
  auto *rb = new RubberBand::RubberBandStretcher(44100, 1);
  auto version = rb->getEngineVersion();
  delete rb;
  return version;
}
