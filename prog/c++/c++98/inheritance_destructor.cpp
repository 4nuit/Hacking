#include <stdio.h>

class A {
    public:
        A(){printf("A()" "\n");}
        virtual ~A() {printf("~A()" "\n");}
};

class B: public A {
    public:
        B(){printf("B()" "\n");}
        ~B(){printf("~B()" "\n");}
};

int main() {
    // A()
    // B()
    A* a= new B;
    // Destructor are called in reversed order
    // ~B()
    // ~A()
    a->~A();
}
