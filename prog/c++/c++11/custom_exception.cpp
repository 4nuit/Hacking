#include <iostream>
#include <vector>
#include <algorithm>
#include <stdexcept>

class CustomException : public std::exception {
public:
    CustomException(const char* message) : msg_(message) {}
    
    const char* what() const noexcept override {
        return msg_;
    }
private:
    const char* msg_;
};

void divideNumbers(int dividend, int divisor) {
    if (divisor == 0) {
        throw CustomException("Division by zero!");
    }
    std::cout << "Result: " << static_cast<double>(dividend) / divisor << '\n';
}

int main() {
    try {
        divideNumbers(10, 0);
    } catch (const std::exception& e) {
        std::cerr << "Caught exception: " << e.what() << '\n';
    }

    divideNumbers(5, 0);
}
