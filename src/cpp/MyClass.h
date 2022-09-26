//
// Created by Tobias Hegemann on 26.09.22.
//

#ifndef AUDIOWORKLET_WASM_TYPESCRIPT_STARTER_CPP_MYCLASS_H_
#define AUDIOWORKLET_WASM_TYPESCRIPT_STARTER_CPP_MYCLASS_H_

#include <string>

class MyClass {
 public:
  MyClass();

  int multiply(int a, int b);

  std::string sayHello(std::string name);
};

#endif //AUDIOWORKLET_WASM_TYPESCRIPT_STARTER_CPP_MYCLASS_H_
