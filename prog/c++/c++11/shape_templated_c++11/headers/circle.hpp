#ifndef CIRCLE_HPP_
#define CIRCLE_HPP_

#include <iostream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <memory>

// Base class for shapes
class Shape {
public:
    virtual double area() const = 0; // Pure virtual function for area
    virtual void printInfo() const = 0; // Virtual function for printing info
    virtual ~Shape() = default; // Virtual destructor
};

// Derived class Circle
class Circle : public Shape {
private:
    double x, y;
protected:
    int r;
public:
    Circle(double x, double y, int r);
    Circle(const Circle& other);
    virtual ~Circle();

    // Accessors
    double getX() const;
    double getY() const;
    int getR() const;

    // Mutators
    int setR(int radius);

    // Overriding base class methods
    double area() const override;
    void printInfo() const override;

    // Equality and comparison operators
    bool operator==(const Circle& other) const;
    bool operator<(const Circle& other) const;
};

// Template function for calculating properties
template <typename T>
double calculateTotalArea(const std::vector<std::shared_ptr<T>>& shapes) {
    double total = 0.0;
    for (const auto& shape : shapes) {
        total += shape->area();
    }
    return total;
}

#endif // CIRCLE_HPP_
