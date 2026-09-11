#include <iostream>
#include <complex>
#include <vector>
#include <map>
#include <set>

void demonstrateIssues() {
    // Shallow Copy
    int *a = new int(10);
    int *b = a;   // shallow copy: both point to same memory

    *b = 20;      // changing b also changes a
    std::cout << "Shallow Copy:" << "\n";
    std::cout << "a = " << *a << ", b = " << *b << "\n";  // both 20

    // Deep Copy
    int *x = new int(10);
    int *y = new int(*x);  // deep copy: new memory with same value

    *y = 30;      // changing y does not affect x
    std::cout << "\nDeep Copy:" << "\n";
    std::cout << "x = " << *x << ", y = " << *y << "\n";  // x=10, y=30

    delete a; // free memory
    // delete b;  // dangerous in shallow copy (same memory as a)
    delete x;
    delete y;


    // Immutable types
    int xx = 42;
    int yy = xx;  // Copy by value
    yy += 1;
    std::cout << "Integer: " << xx << " " << yy << "\n";

    double z = 3.14;
    double w = z;  // Copy by value
    w += 1.0;
    std::cout << "Float: " << z << " " << w << "\n";

    std::complex<double> c(2, 3);
    std::complex<double> d = c;  // Copy by value
    d += std::complex<double>(1, 0);
    std::cout << "Complex: " << c << " " << d << "\n";

    // Mutable types
    std::vector<int> lst = {1, 2, 3};
    std::vector<int> lst_copy = lst;  // Deep copy by default
    lst_copy[0] = 2;
    std::cout << "List: " << lst[0] << " " << lst_copy[0] << "\n";

    std::map<std::string, std::string> dct = {{"key", "value"}};
    std::map<std::string, std::string> dct_copy = dct;  // Deep copy
    dct_copy["key"] = "new_value";
    std::cout << "Dict: " << dct["key"] << " " << dct_copy["key"] << "\n";

    std::set<int> st = {1, 2, 3};
    std::set<int> st_copy = st;  // Deep copy
    st_copy.insert(42);
    std::cout << "Set: " << *st.begin() << " " << *st_copy.begin() << "\n";
    for (auto& e : st)
        std::cout << e;
    std::cout << "\n";
    for (auto& e : st_copy)
        std::cout << e;
}

int main() {
    demonstrateIssues();
    return 0;
}
