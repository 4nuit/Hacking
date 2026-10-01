#include "../headers/circle.hpp"

// Constructor using initialization list
Circle::Circle(double x, double y, int r) : x(x), y(y), r(r) {}

// Copy constructor
Circle::Circle(const Circle& other) : x(other.x), y(other.y), r(other.r) {}

// Destructor
Circle::~Circle() = default;

// Accessor implementations
double Circle::getX() const {
    return x;
}

double Circle::getY() const {
    return y;
}

int Circle::getR() const {
    return r;
}

// Mutator implementation
int Circle::setR(int radius) {
    return (r = radius); // Assign and return
}

// Area implementation
double Circle::area() const {
    return M_PI * r * r; // Area of the circle
}

// Print information about the circle
void Circle::printInfo() const {
    std::cout << "Circle at (" << x << ", " << y << ") with radius " << r 
              << " and area " << area() << '\n';
}

// Equality operator
bool Circle::operator==(const Circle& other) const {
    return x == other.x && y == other.y && r == other.r;
}

// Less-than operator for comparison (based on area)
bool Circle::operator<(const Circle& other) const {
    return area() < other.area();
}
