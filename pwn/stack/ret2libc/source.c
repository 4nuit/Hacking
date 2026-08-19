//gcc source.c -o vuln-32 -no-pie -fno-stack-protector -m32
//gcc source.c -o vuln-64 -no-pie -fno-stack-protector


#include <stdio.h>

void vuln() {
    char buffer[64];

    puts("Overflow me");
    gets(buffer);
}

int main() {
    vuln();
}