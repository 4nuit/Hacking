#include <iostream>
#include <thread>

static bool s_Finished = false;

void DoWork(){
	using namespace std::literals::chrono_literals;

	std::cout << "Started thread id  =" << std::this_thread::get_id() << std::endl;
	
	while(!s_Finished){
		std::cout << "Working..." << std::endl;
		std::this_thread::sleep_for(1s);
	}
}

int main(){
	// creating *DoWork thread
	std::thread worker(DoWork);
	
	std::cin.get();
	s_Finished = true;

	// main thread waits for *DoWork thread to finish its execution to join
	worker.join();
	std::cout << "Finished" << std::endl;

	// starting another thread
	std::cout << "Started thread id  =" << std::this_thread::get_id() << std::endl;
	
	std::cin.get();
	return 0;
}
