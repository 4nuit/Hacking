/*
 * - Does the code compile?
 * - What prints the code?
 * - How to fix?
*/

#include <iostream>
#include <vector>

class Animal{	
	public:

		void speak(){
			std::cout << "Hello, I am an Animal\n";
		}

		void type(){
			std::cout << "Screams\n";
		}

		~Animal(){
			std::cout << "Animal deleted\n";
		}
};

class Dog : public Animal{
	public:

		void speak() const override{
			std::cout << "Hello, I am an Dog\n";
		}

		void type(){
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

		void type(){
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
		animal -> ~Animal();
	}
	return 0;
}
