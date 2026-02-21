// Modify the class Ref, and only this class, so that
// the call to f(make_ref(j)) modify the value of j,
// although f(i) does not modify i.
// The final display should be : 0 42
#include <iostream>
template<typename T>
    class Ref {
        public :
            // Initialization lists are necessary to initialize constant data members and references, which cannot be assigned values after the object is created
            Ref(T& data): m_data(data){}

    void operator=(T&& data){ m_data = data; std::cout << m_data << "\n";}
    //OR
    //void operator=(const T& data){ m_data = data; std::cout << m_data << "\n";}

    private:
        T& m_data;
    };

template<typename T>
    void f(T data) {
        // Assignment operator is called when an already initialized object is assigned a new value from another existing object
        data = 42;
    }


int main() {
    int i = 0, j = 0;
    f(i);
    f(Ref<int>(j));
    std::cout << i << " " << j << std::endl;    // 0 0 -> 0 42
    return 0 ;
}
