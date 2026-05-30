#include <stdio.h>
#include "simdlib.h"

int main() {

	long a;
	long b;
	long c[4] = {5, 3, 1, 9};
	long d[4] = {5, 6, 7, 8};
	long array_result[4];

	add_arrays(c, d, array_result, 4);

	printf("Array addition:\n");
	for (int i = 0; i < 4; i++) {
		printf("c[%d] + d[%d] = %ld\n", i, i, array_result[i]);
	}

	printf("\n");

	simd_add_arrays(c, d, array_result, 4);
	printf("SIMD Array addition:\n");
	for (int i = 0; i < 4; i++) {
		printf("c[%d] + d[%d] = %ld\n", i, i, array_result[i]);
	}

	printf("\n");

	subtract_arrays(c, d, array_result, 4);

	printf("Array subtraction:\n");
	for (int i = 0; i < 4; i++) {
		printf("c[%d] - d[%d] = %ld\n", i, i, array_result[i]);
	}

	printf("\n");

	simd_subtract_arrays(c, d, array_result, 4);

	printf("SIMD Array subtraction:\n");
        for (int i = 0; i < 4; i++) {
                printf("c[%d] - d[%d] = %ld\n", i, i, array_result[i]);
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
