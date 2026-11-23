/*
 * - Does the code compile?
 * - What prints the code?
 * - How to fix?
 */

#include <iostream>
#include <vector>

class Animal{
public:

    // virtual methods
    // in this case, const (signature's     last word), ensures the method does not changes internal state of any member
    virtual void speak() const{
        std::cout << "Hello, I am an Animal\n";
    }

    virtual void type() const{
        std::cout << "Screams\n";
    }

    // destructors may not be cv-qualified
    virtual ~Animal(){
        std::cout << "Animal deleted\n";
    }
};

class Dog : public Animal{
public:

    /*
     * override helps to check if:
     *  - there is a method with the same name in the parent class
     *  - the method in the parent class is declared as virtual which means it was intented to be rewritten
     *  - the method in the parent class has the same signature as the method in the subclass
     */
    void speak() const override{
        std::cout << "Hello, I am an Dog\n";
    }

    void type() const override{
        std::cout << "Woof\n";
    }

    ~Dog(){
        std::cout << "Dog deleted\n";
    }
};

class Cat : public Animal{
public:

    void speak() const override{
        std::cout << "Hello, I am an Cat\n";
    }

    void type() const override{
        std::cout << "Meow\n";
    }

    ~Cat(){
        std::cout << "Cat deleted\n";
    }
};

int main(){

    std::vector<Animal *> vec = {new Animal(), new Dog(), new Cat()};
    for (const auto& animal: vec){
        animal -> speak();
        animal -> type();

        // Properly deleting animal (All heap blocks were freed -- no leaks are possible)
        delete animal;
    }
    return 0;
}
