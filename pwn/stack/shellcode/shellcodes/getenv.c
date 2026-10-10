//gcc -m32 -o getenv getenv.c
//obtenir l'adresse d'une variable d'environnement contenant shellcode 
//./vuln <padding +addresse env
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    char *ptr;
    ptr = getenv(argv[1]);
    if( ptr == NULL )
    printf("%s not found\n", argv[1]);
    else printf("%s found at %08x\n", argv[1], (unsigned int)ptr);
    return 0;
} 
    
