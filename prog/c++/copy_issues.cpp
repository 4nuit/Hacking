#include <iostream>
#include <vector>
#include <map>
#include <set>

void demonstrateIssues() {
    // Immutable types
    int x = 42;
    int y = x;  // Copy by value
    y += 1;
    std::cout << "Integer: " << x << " " << y << "\n";

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
    lst_copy[0] = 42;
    std::cout << "List: " << lst[0] << " " << lst_copy[0] << "\n";

    std::map<std::string, std::string> dct = {{"key", "value"}};
    std::map<std::string, std::string> dct_copy = dct;  // Deep copy
    dct_copy["key"] = "new_value";
    std::cout << "Dict: " << dct["key"] << " " << dct_copy["key"] << "\n";

    std::set<int> st = {1, 2, 3};
    std::set<int> st_copy = st;  // Deep copy
    st_copy.insert(42);
    std::cout << "Set: " << *st.begin() << " " << *st_copy.begin() << "\n";
}

int main() {
    demonstrateIssues();
    return 0;
}
