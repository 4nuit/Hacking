//std::sharded_ptr = smart pointer which manages the memory of each (shared) pointed objects
//automatically deleted when no shared_ptr instaces refer to it

#include <iostream>
#include <memory> // For std::shared_ptr
#include <vector> // For std::vector

// A base class for shapes
class Shape {
public:
    virtual void draw() const = 0; // Pure virtual function
    virtual ~Shape() = default;
};

// A derived class for circles
class Circle : public Shape {
private:
    double radius;
public:
    Circle(double r) : radius(r) {}
    void draw() const override {
        std::cout << "Drawing a Circle with radius: " << radius << '\n';
    }
};

// A derived class for rectangles
class Rectangle : public Shape {
private:
    double width, height;
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    void draw() const override {
        std::cout << "Drawing a Rectangle with width: " << width
                  << " and height: " << height << '\n';
    }
};

int main() {
    // Create a vector of shared pointers to shapes
    std::vector<std::shared_ptr<Shape>> shapes;

    // Add shapes to the collection
    //shapes.push_back(std::make_shared<Circle>(5.0)); // Circle with radius 5
    //shapes.push_back(std::make_shared<Rectangle>(4.0, 6.0)); // Rectangle with width 4 and height 6
    // => Use brace initializers and auto iterators

    shapes = {std::make_shared<Circle>(5.0), std::make_shared<Rectangle>(4.0, 6.0)};
    
    // Iterate and draw each shape
    for (const auto& shape : shapes) {
        shape->draw(); // Polymorphic call
    }

    return 0;
}
