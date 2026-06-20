// Source - https://stackoverflow.com/q/9507008
// Posted by rcplusplus
// Retrieved 2026-06-20, License - CC BY-SA 3.0

#include <iostream>
#include <string>
using namespace std;

class Wrapper
{
public:
   // Passing a lvalue reference
   string& str;

   // Initialization in the parametrized constructor: str is immediately bound to newStr (real string) in the initializer list
   Wrapper(string& newStr): str(newStr) {}
};

int main (int argc, char * const argv[]) 
{
   // Defining a real string object (not char*) so it can be referenced
   string str("hello");
   cout << str << endl;
   Wrapper wrapper(str);

   wrapper.str[0] = 'j'; // should change 'hello' to 'jello'
   cout << str << endl;
}
