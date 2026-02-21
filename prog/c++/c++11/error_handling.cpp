#include <iostream>
#include <typeinfo>

template <typename T, typename S> T max(T a,S b){
        if (a>b) return a;
        return b;
}

class something_went_wrong {};

int main(){
        std::cout << max(-1,2) << std::endl;
        throw(something_went_wrong{});
        // calls std::terminate and abort

        double pi(3.14);
        double sqrt2(1.41);
        std::cout << typeid(pi).name() << std::endl;
        std::cout << max(pi,sqrt2) << std::endl;
        return 0;
}

