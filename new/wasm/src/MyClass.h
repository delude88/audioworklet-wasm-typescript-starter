//
// Created by Tobias Hegemann on 26.09.22.
//

#ifndef AUDIOWORKLET_WASM_TYPESCRIPT_STARTER_CPP_MYCLASS_H_
#define AUDIOWORKLET_WASM_TYPESCRIPT_STARTER_CPP_MYCLASS_H_

#include <string>
#include <RubberBandStretcher.h>

class MyClass {
 public:
  MyClass();

  float multiply(float a, float b);

  std::string sayHello(std::string name);

  int getDefaultRubberbandEngineVersion();
};

#endif //AUDIOWORKLET_WASM_TYPESCRIPT_STARTER_CPP_MYCLASS_H_
