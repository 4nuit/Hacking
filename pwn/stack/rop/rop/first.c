#include <stdio.h>
 
int main()
{
  int  useless;
  int var = 0x30313233;
  char buf[40];
  gets(buf,stdin);
 
  printf("\nYou wrote: %s\n", buf);
  printf("[var]: %p\n", var);
  return 0;
}
