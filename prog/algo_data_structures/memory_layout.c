// The memory layout of the program is as follows:
// 1. Text segment: contains the executable code
// 2. Data - Initialized data segment: contains the global variables that are
//    initialized by the programmer
// 3. BSS - Uninitialized data segment: contains the global variables that are
//    not initialized by the programmer
// 4. Stack: contains the local variables and function calls
// 5. Heap: contains the dynamically allocated memory

int global;                 // uninitialized global variable --> bss
int initialized_global = 1; // initialized global variable --> data

int main(void)
{
    int local;                 // uninitialized local variable --> stack
    int initialized_local = 2; // initialized local variable --> stack

    char *uninit_pointer; // uninitialized pointer --> stack

    uninit_pointer = (char *)malloc(10); // dynamically allocated memory --> heap

    return 0;
}
