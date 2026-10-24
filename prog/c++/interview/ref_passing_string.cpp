// Source - https://stackoverflow.com/q/9507008
// Posted by rcplusplus
// Retrieved 2026-06-20, License - CC BY-SA 3.0

#include <iostream>
#include <string>
using namespace std;

class Wrapper
{
public:
   string str;

   Wrapper(const string& newStr)
   {
      str = newStr;
   }
};

int main (int argc, char * const argv[]) 
{
   string str = "hello";
   cout << str << endl;
   Wrapper wrapper(str);
   wrapper.str[0] = 'j'; // should change 'hello' to 'jello'
   cout << str << endl;
}
