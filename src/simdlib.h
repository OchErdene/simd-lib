#ifndef SIMDLIB_H
#define SIMDLIB_H

long add(long a, long b);
long multiply(long a, long b);
long subtract(long a, long b);
long divide(long a, long b);
void add_arrays(long *a, long *b, long *result, long len);
void simd_add_arrays(long *a, long *b, long *result, long len);
void subtract_arrays(long *a, long *b, long *result, long len);
void simd_subtract_arrays(long *a, long *b, long *result, long len);
double dot_product(double *a, double *b, long len);
double simd_dot_product(double *a, double *b, long len);

#endif
