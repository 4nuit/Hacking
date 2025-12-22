#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void caesar(char *s){
	int i;
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
