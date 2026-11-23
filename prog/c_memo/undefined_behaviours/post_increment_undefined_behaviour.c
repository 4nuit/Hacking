//gcc post*; ./a.out; echo $?
int main(void) {
	int i = 0;
	//++i <=> increment i; and return new i
	//i++ <=> increment i; but returns old i
	// i = 1; j = ++i => j=2
	// i = 1; j = i++ => j=1
	// In any case, follow the guideline "prefer ++i over i++" and you won't go wrong
	// returns 3 byt undefined behaviour
	// i++ + ++i would return 2 with the same UB
	return ++i + i++;
}
