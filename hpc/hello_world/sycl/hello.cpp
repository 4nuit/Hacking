#include <sycl/sycl.hpp>

using namespace sycl;

int main(int argc, char* argv[]) {
    //sycl::queue
    queue q;
    std::cout << "Running on " << q.get_device().get_info<sycl::info::device::name>() << "\n";
    //constructeur ->queue(const DeviceSelector &deviceSelector,const property_list &propList = {});
    //ex: queue q{gpu_selector_v};
    //sycl::handler 
    //lambda -> capture par reference tous les handlers &cg

    //Commande
    q.submit([&](handler& cg) {
        //sycl::stream
        auto os = stream{1024, 1024, cg}; 
        //sycl::id
        //Rq : sycl::idx == sycl:id<1>
        //kernel - appel asynchrone / out of order  - lambda -> capture tous les pid par valeur
        cg.parallel_for(10, [=](id<1> myid){
            os << "Hello World! My ID is " << myid << "\n";
        });
        // Fin du kernel
    });
    // Les handlers sont detruits une fois hors de la file
    return 0;
}