#include <iostream>
class X {
public:
// "ordinary constructor": create an object
X(int a) {
std::cout << "X::X(int)" << std::endl;
}
// Default constructor
X() {
std::cout << "X::X()" << std::endl;
}
// Copy constructor
X(const X&) {
std::cout << "X::X(const X&)" << std::endl;
}
// Move constructor
X(X&&) noexcept {
std::cout << "X::X(X&&)" << std::endl;
}
// Copy assignment: clean up the target and copy
X& operator=(const X&) {
std::cout << "X::operator=(X&)" << std::endl;
}
// Move assignment: clean up the target and move
X& operator=(X&&) noexcept {
std::cout << "X::operator=(X&&)" << std::endl;
}
// Destructor: clean up
~X() {
std::cout << "~X()" << std::endl;
}
};
class Y: public X {
public:
~Y(){}
};
int main(int argc, char** argv) {
/*
X::X()
X::X(const X&)
~X()
~X()
*/
Y a;
Y b(std::move(a));
}
