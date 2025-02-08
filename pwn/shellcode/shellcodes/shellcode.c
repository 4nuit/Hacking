#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>


int main(int argc, char ** argv){

    void (* shellcode)(void) = mmap(0, 0x1000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);

    gets(shellcode);

    shellcode();
}