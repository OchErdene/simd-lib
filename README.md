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

Tested on x86-64 Linux (AVX2), 1 billion iterations:

| Implementation | Time | Speed |
|---|---|---|
| Scalar `add_arrays` | 0.183s | 1x |
| SIMD `simd_add_arrays` | 0.092s | **1.98x** |

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
