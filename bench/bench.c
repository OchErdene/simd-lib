#include <stdio.h>
#include <time.h>

void add_arrays(long *a, long *b, long *result, long len);
void simd_add_arrays(long *a, long *b, long *result);

#define SIZE 4
#define ITERATIONS 100000000

int main() {
	long a[SIZE] = {1, 2, 3, 4};
	long b[SIZE] = {5, 6, 7, 8};
	long result[SIZE];

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
		simd_add_arrays(a, b, result);
	}
	end = clock();
	double simd_time = (double)(end - start) / CLOCKS_PER_SEC;
	printf("SIMD: %.3f seconds\n", simd_time);

	printf("Ratio: %.2fx\n", scalar_time / simd_time);

	return 0;
}
