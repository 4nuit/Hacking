#include "../headers/circle.hpp"
#include <vector>
#include <memory>

int main() {
    // Create a vector of shared pointers to shapes
    std::vector<std::shared_ptr<Shape>> shapes;

    // Use lambdas to create circles dynamically and add them to the collection
    auto createCircle = [](double x, double y, int r) {
        return std::make_shared<Circle>(x, y, r);
    };

    shapes = {createCircle(1.0, 2.5, 4), createCircle(2.0, 3.5, 5), createCircle(0.0, 0.0, 3)};

    // Iterate over shapes using auto and print their information
    std::cout << "Shapes Information:\n";
    for (const auto& shape : shapes) {
        shape->printInfo();
    }

    // Calculate total area using the template function
    double totalArea = calculateTotalArea(shapes);
    std::cout << "\nTotal area of all shapes: " << totalArea << '\n';

    // Sort shapes by area using std::sort and a lambda
    std::sort(shapes.begin(), shapes.end(), 
        [](const std::shared_ptr<Shape>& a, const std::shared_ptr<Shape>& b) {
            return a->area() < b->area();
        });

    std::cout << "\nShapes sorted by area:\n";
    for (const auto& shape : shapes) {
        shape->printInfo();
    }

    return 0;
}
