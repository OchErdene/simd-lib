#include<stdio.h>

long add(long a, long b);
long multiply(long a, long b);
long subtract(long a, long b);
long divide(long a, long b);
void add_arrays(long *a, long *b, long *result, long len);
void simd_add_arrays(long *a, long *b, long *result);

int main() {

	long a;
	long b;
	long c[4] = {1, 2, 3, 4};
	long d[4] = {5, 6, 7, 8};
	long array_result[4];

	add_arrays(c, d, array_result, 4);

	printf("Array addition:\n");
	for (int i = 0; i < 4; i++) {
		printf("c[%d] + d[%d] = %ld\n", i, i, array_result[i]);
	}

	printf("\n");

	simd_add_arrays(c, d, array_result);
	printf("SIMD Array addition:\n");
	for (int i = 0; i < 4; i++) {
		printf("c[%d] + d[%d] = %ld\n", i, i, array_result[i]);
	}

	printf("\n");


	scanf("%ld", &a);
	scanf("%ld", &b);

	long result = add(a, b);
	printf("%ld + %ld = %ld\n", a, b, result);

	result = multiply(a, b);
	printf("%ld * %ld = %ld\n", a, b, result);

	result = subtract(a, b);
	printf("%ld - %ld = %ld\n", a, b, result);

	result = divide(a, b);
	printf("%ld / %ld = %ld\n", a, b, result);

	return 0;
}
