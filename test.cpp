#include <cassert>
#include <cmath>    // For trigonometric functions
#include "Class_H.h"

// Main function to test FuncA
int main() {
    MyClass obj;

    // Expected result based on the calculation
    double expected_value = std::tan(0) + std::tan(1) - std::tan(2);

    // Call FuncA and compare the result using assert
    assert(std::fabs(obj.FuncA() - expected_value) < 1e-9 && "Test Failed: FuncA() returned unexpected value");

    // If assert doesn't fail, the test passed
    return 0;
}

