#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void caesar_base(char *s){
	int i = 0;
	// while s[i] is not '\0'
	while (s[i]) {
		// s[i] + 13 % 26
		if (s[i] >= 'a' + 13)
			s[i] -= 13;
		else
			s[i] += 13;
		i += 1;
	}
}

void caesar(char *s){
	int i = 0;
	while (s[i]) {
		// s[i] < 65 || s[i] > 90
		if ( s[i] < 'A' || s[i] > 'Z'){

			//  s[i] < 97 || s[i] > 122
			if ( s[i] < 'a' || s[i] > 'z'){
				//do nothing on non printable chars : 91 < c < 95
			}
			else{
				//s[i] = (s[i] - 84) % 26 + 97
				s[i] = (s[i] - ('a' - 13)) % 26 + 'a';
			}
		}
		else
			//s[i] = (s[i] - 52) % 26 + 65
			s[i] = (s[i] - ('A' - 13)) % 26 + 'A';
		i += 1;
	}
}

int main(int argc, char** argv){

	if (argc != 2) {
		printf("Usage: ./caesar word");
		return -1;
	}

	char* s = argv[1];
	caesar(s);
	for (int i = 0; i < strlen(s); i++){
		printf("%c", s[i]);
	}
	
	return 0;
}
