#include <iostream>
#include <cstdint>  // For uint8_t

int main() {
    std::cout << "Enter a number:";
    int x = 10;
    // uint8_t can only hold values from 0 to 255
    uint8_t y;
    
    if (std::cin >> y) {
        // Only the first char is stored: 11 -> 1 = chr(49)
        std::cout << y;
        // x = 49 * 10
        x *= y;
        std::cout << "Result: " << x << std::endl;
    } else {
        std::cout << "Invalid input! Please enter a valid number." << std::endl;
    }
    
    return 0;
}
