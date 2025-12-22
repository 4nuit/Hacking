#include <unistd.h>
#include <stdio.h>

int main(void)
{
    srand(1337, 1, 1, 0x7ffbd62bfa77);
    int a = rand(0xffffffff, 0x7ffbd63c4860, 0x7ffbd63c4204, 0x7ffbd63c4280)    ;
    printf("%d\n", a);
}
