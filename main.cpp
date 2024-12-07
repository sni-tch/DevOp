#include <iostream>
#include "Class_H.h"

int main() {
    MyClass obj;  // Create an object of MyClass
    double result = obj.FuncA();  // Call the FuncA function
    std::cout << "The result of FuncA is: " << result << std::endl;  // Output the result
    return 0;
}