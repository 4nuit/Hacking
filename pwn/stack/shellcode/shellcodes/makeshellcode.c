#include <stdio.h>

void sh();

int main()
{
  char * ptr = (char *) sh;
  printf("char shellcode[] = \n\"");
  
  while(*ptr != 0)
  {
  printf("\\x%.2x",*ptr & 0xff);
  ptr++;
}

printf("\";\n");
} 
