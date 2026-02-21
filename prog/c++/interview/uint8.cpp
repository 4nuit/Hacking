#include <iostream>
#include <cstdint>  // For uint8_t

int main() {
    std::cout << "Enter a number:";
    int x = 10;
    uint8_t y;
    
    if (std::cin >> y) {
        // What if y = 11?
        x *= y;
        std::cout << "Result: " << x << std::endl;
    } else {
        std::cout << "Invalid input! Please enter a valid number." << std::endl;
    }
    
    return 0;
}
