//g++ -std=c++98 circle.cpp -o circle

#include <iostream>
#include <math.h>
#include <typeinfo>
#include "circle.hpp"

//Circle::Circle(double x, double y, int r){
//    this->x = x;
//    this->y = y;
//    this->r = r;
//}
// C++98/03 standard initialization list
Circle::Circle(double x, double y, int r) : x(x), y(y), r(r) {}

//Circle::Circle(const Circle* original){
//    x = original->x;
//    y = original->y;
//}
// C++98/03 standard initialization list
Circle::Circle(const Circle& original) : x(original.x), y(original.y), r(original.r) {}

Circle::~Circle(){}

double Circle::getX(){
    return x;
}

double Circle::getY(){
    return y;
}

int Circle::getR(){
    return r;
}

double Circle::area(){
    return M_PI*r*r;
}

//int Circle::setR(int r){
//    this->r = r;
//    return r;
//}

int Circle::setR(int radius) {
    r = radius;
    return r;
}

//const ensures that == doesnt change any object
bool Circle::operator==(const Circle& circle) const{
    return x == circle.x && y == circle.y && r == circle.r;
}

//bool operator==(const Circle& lhs, const Circle& rhs) {
//    return lhs.getX() == rhs.getX() && lhs.getY() == rhs.getY() && lhs.getR() == rhs.getR();


int main(){
    Circle circle1(1.0,2.5,4);
    int radius1 = circle1.getR();
    int* pointer1 = &radius1;
    double area1 = circle1.area();
    std::cout << typeid(circle1).name() << " Circle1 radius: " << radius1 << std::endl;
    std::cout << typeid(pointer1).name() << " &Circle1: " << pointer1 << std::endl;
    std::cout << typeid(area1).name() << " Circle1 area: " << area1 << std::endl;

    Circle circle2 = circle1;
    int radius2 = circle2.getR();
    int* pointer2 = &radius2;
    double area2 = circle2.area();
    std::cout << typeid(circle2).name() << " Circle2 radius:" << radius2 << std::endl;
    std::cout << typeid(pointer2).name() << " &Circle2: " << pointer2 << std::endl;
    std::cout << typeid(area2).name() << " Circle2 area: " << area2 << "\n" << std::endl;

    std::cout << "Compare the 2 circles - same values " << std::endl;    
    std::cout << (circle1 == circle2) << std::endl;

    std::cout << " Change radius2: " << std::endl;
    circle2.setR(3);
    radius1 = circle1.getR();
    radius2 = circle2.getR();
    area1 = circle1.area();
    area2 = circle2.area();
    std::cout << typeid(circle1).name() << " Circle1 radius: " << radius1 << std::endl;
    std::cout << typeid(area1).name() << " Circle1 area: " << area1 << std::endl;
    std::cout << typeid(area2).name() << " Circle2 area: " << area2 << std::endl;

    Circle circle3(1,3,4);

    std::cout << "Comparing: circle2.r!=circle1.r && circle3.y!=circle1.y " << std::endl;    
    std::cout << (circle1 == circle2) << std::endl;
    std::cout << (circle1 == circle3) << std::endl;

    return 0;
}
