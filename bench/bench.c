#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void add_arrays(long *a, long *b, long *result, long len);
void simd_add_arrays(long *a, long *b, long *result, long len);

#define SIZE 10000
#define ITERATIONS 100000

int main() {
	long *a = malloc(SIZE * sizeof(long));
	long *b = malloc(SIZE * sizeof(long));
	long *result = malloc(SIZE * sizeof(long));

	for (int i = 0; i < SIZE; i++) {
    		a[i] = i + 1;
    		b[i] = i + 2;
	}

	clock_t start, end;

	//benchmanrk test for regular array addition in assembly
	start = clock();
	for (long i = 0; i < ITERATIONS; i++) {
		add_arrays(a, b, result, SIZE);
	}
	end = clock();
	double scalar_time = (double)(end-start) / CLOCKS_PER_SEC;
	printf("Scalar: %.3f seconds\n", scalar_time);

	//benchmark test for simd array addition in assembly (4 by 4)
	start = clock();
	for (long i = 0; i < ITERATIONS; i++) {
		simd_add_arrays(a, b, result, SIZE);
	}
	end = clock();
	double simd_time = (double)(end - start) / CLOCKS_PER_SEC;
	printf("SIMD: %.3f seconds\n", simd_time);

	printf("Ratio: %.2fx\n", scalar_time / simd_time);

	return 0;
}
