#include <stdio.h>
#include "shellcode.h"

int main()
{
printf("taille : %d\n",sizeof(shellcode)-1);
int *ret;
*( (int *) &ret + 2) = (int) shellcode;
} 
