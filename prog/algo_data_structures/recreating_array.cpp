#include <iostream>
#include <cstring>

// Mimicking std::array using C-style arrays
// size_t allows negative indexes
template<typename T, size_t S>
class Array{

	private:

		T m_Data[S];

	public:

		static unsigned long m_constructor_count, m_destructor_count;

		// Default constructor to initialize all elements with the default value of T
		// overloaded: optional if no constructor is available
		Array() {
			std::cout << "Using default constructor" << std::endl;
			for (size_t i = 0; i < S; ++i) {
				m_Data[i] = T();  // Initialize with the default value of type T (e.g., 0 for int)
			}

			++m_constructor_count;
		}

		// Constructor to initialize with specific values using initializer list
		Array(std::initializer_list<T> list) {
			std::cout << "Using initializer_list constructor" << std::endl;
			size_t i = 0;
			for (const T& val : list) {
				if (i < S) {
					m_Data[i] = val;
					++i;
				}
			}
			++m_constructor_count;
		}

		~Array(){
			++m_destructor_count;
		}

		// Returns the size of the array
		constexpr size_t Size() const { return S; }

		// Allowing to access AND modify Array[]
		T& operator[](size_t index) { std::cout << "Using T& operator[] \n"; return m_Data[index]; }
		const T& operator[](size_t index) const { std::cout << "Using const T& operator[] \n"; return m_Data[index]; }

		// Allowing to access *Array
		T* Data() { return m_Data; }
		//const T* Data() const { return m_Data; }
};

// Define static member variables
template<> unsigned long Array<int, 5>::m_constructor_count = 0;
template<> unsigned long Array<int, 5>::m_destructor_count = 0;

template<> unsigned long Array<std::string, 2>::m_constructor_count = 0;
template<> unsigned long Array<std::string, 2>::m_destructor_count = 0;


int main(){
	const size_t size = 5;

	// Using valued constructor (initializer_list)
	Array<int,size> array{1,2,3,4,5};

	// Using Size()
	std::cout << "array:" << std::endl;
	for (size_t i = 0; i < array.Size(); i++){

		// Using int operator[] to for read-only access
		std::cout << array[i] << "\n";
	}

	// Using default constructor
	Array<int,size> data;

	// Using int* Data()
	memset(data.Data(), 0, data.Size()*sizeof(int));
	const auto& dataReference = data;


	std::cout << "data:" << std::endl;
	for (size_t i = 0; i < data.Size(); i++){

		// Using int& operator[] as modifiable lvalue
		data[i] = 2;

		// Using int operator[] to for read-only access (would be a second call to int& operator[] here)
		// std::cout << data[i] << "\n";
	}

	std::cout << "dataReference:" << std::endl;
	for (size_t i = 0; i < dataReference.Size(); i++){

		// Using const int& operator[]
		std::cout << dataReference[i] << "\n";
	}

	// Using default constructor
	Array<std::string, 2> data2;
	data2[0] = "Cherno";
	data2[1] = "C++";

	std::cout << "data2:" << std::endl;
	for (size_t i = 0; i < data2.Size(); i++){
		std::cout << data2[i] << "\n";
	}

	std::cout << "Constructor calls for data: " << Array<int, 5>::m_constructor_count << std::endl;
	std::cout << "Destructor counts: " << Array<int, 5>::m_destructor_count << std::endl;
	std::cout << "Constructor calls for data2: " << Array<std::string, 2>::m_constructor_count << std::endl;
	std::cout << "Destructor counts: " << Array<std::string, 2>::m_destructor_count << std::endl;

	return 0;
}
