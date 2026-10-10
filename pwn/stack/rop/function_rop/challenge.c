#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void win(char *string, long checker, long checker2) {
   puts("Comment est-tu parvenu jusqu'ici ??? GG I guess");
   if (checker == 0x0001020304050607) {
     puts("Tu es sur la bonne voie! Le savais tu : la vie est belle quand une string se termine par /bin/sh");
     if (checker2 == 0x08090b0c0d0e0f10) {
        puts("Bravo!!!");
        system(string);
     }
   }
}

int main() {

   setvbuf(stdout, NULL, _IONBF, 0);

   char buffer[50];
  
   puts("Bienvenue à pwn-land! La sainte terre du pwn.");
   puts("Veuillez saisir votre pseudo :");
   fgets(buffer, 0x100, stdin);

   if (strncmp(buffer, "Soremo", 6) == 0) {
      puts("te revoilà valeureux soldat après des années de service ?!");
   }
   else {
      puts("Bienvenue par minou.");
   }

   return 0;
}
