# simd-lib

Assembly math library for C, featuring SIMD (AVX2) optimized array operations.

## Functions

| Function | Description |
|---|---|
| `add(a, b)` | Add two integers |
| `subtract(a, b)` | Subtract two integers |
| `multiply(a, b)` | Multiply via repeated addition |
| `divide(a, b)` | Divide via repeated subtraction |
| `add_arrays(a, b, result, len)` | Add two arrays element-wise |
| `simd_add_arrays(a, b, result)` | Add two arrays using AVX2 SIMD (4 by 4)|

## Benchmark Results

Tested on x86-64 Linux (AVX2), 100 million iterations:

| Implementation | Time | Speed |
|---|---|---|
| Scalar `add_arrays` | 0.183s | 1x |
| SIMD `simd_add_arrays` | 0.092s | **1.98x** |

| Array Size | Speedup | Bottleneck |
|---|---|---|
| 8 elements | 2.24x | CPU bound |
| 10,000 | 1.49x | Cache bound |
| 8,000,000 | 1.07x | Memory bound |

## Observations

**SIMD is most effective when array size is a multiple of 4.**
AVX2 processes 4 x 64-bit integers per instruction. When the array 
size is not divisible by 4, the remainder is handled by a scalar 
cleanup loop, reducing overall speedup.

| Array Size | Divisible by 4 | Speedup |
|---|---|---|
| 7 elements | No  | **1.18x** |
| 8 elements | Yes | **2.24x** |

## Build

```bash
make
./bin/main
./bin/bench
```

## How it works

Functions are written in NASM assembly (`src/math.asm`) and linked with a C driver (`src/main.c`) using the System V AMD64 calling convention:

- Arguments passed in `rdi`, `rsi`, `rdx`, `rcx`	
- Return value in `rax`
- SIMD uses 256-bit `ymm` registers to process 4 x 64-bit integers per instruction
