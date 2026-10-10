//gcc undefined_behaviour.c ; ./a.out; echo $?
int main(void) {
	int i = 16;
	return (((((i >= i) << i) >> i) <= i));
}
