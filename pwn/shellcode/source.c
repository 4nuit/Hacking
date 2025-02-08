// gcc source.c -o vuln -no-pie -fno-stack-protector -z execstack -m32

#include <stdio.h>

void unsafe() {
    char buffer[300];
    
    puts("Overflow me");
    gets(buffer);
}

void main() {
    unsafe();
}
