section .text 
	global add
	global multiply
	global subtract
	global divide
	global add_arrays
	global simd_add_arrays
	global subtract_arrays
	global simd_subtract_arrays

add:
	mov rax, rdi
	add rax, rsi
	ret

multiply:
	mov rax, 0
	mov rcx, rsi

multiplication_loop:
	add rax, rdi
	dec rcx
	jnz multiplication_loop
	ret

subtract:
	mov rax, rdi
	sub rax, rsi
	ret

divide:
	mov rax, 0
	mov rcx, rdi

division_loop:
	cmp rcx, rsi
	jl div_done
	sub rcx, rsi
	add rax, 1
	jmp division_loop

div_done:
	ret

add_arrays:
	mov r8, 0

add_array_loop:
	mov rax, [rdi]
	add rax, [rsi]
	mov [rdx], rax
	add r8, 1
	add rdi, 8
	add rsi, 8
	add rdx, 8
	cmp r8, rcx
	jl add_array_loop
	ret

simd_add_arrays:
	mov r8, 0

simd_add_loop:
	mov rax, rcx
	sub rax, r8
	cmp rax, 4
	jl addition_scalar_cleanup
	vmovdqu ymm0, [rdi]
	vmovdqu ymm1, [rsi]
	vpaddq ymm2, ymm0, ymm1
	vmovdqu [rdx], ymm2
	add r8, 4
	add rdi, 32
	add rsi, 32
	add rdx, 32
	cmp r8, rcx
	jl simd_add_loop

addition_scalar_cleanup:
	cmp r8, rcx
	jge scalar_done
	mov rax, [rdi]
	add rax, [rsi]
	mov [rdx], rax
	add r8, 1
	add rdi, 8
	add rsi, 8
	add rdx, 8
	jmp addition_scalar_cleanup

scalar_done:
	ret

subtract_arrays:
	mov r8, 0

subtract_array_loop:
	mov rax, [rdi]
	sub rax, [rsi]
	mov [rdx], rax
	add r8, 1
	add rdi, 8
	add rsi, 8
	add rdx, 8
	cmp r8, rcx
	jl subtract_array_loop
	ret

simd_subtract_arrays:
	xor r8d, r8d

simd_subtraction_loop:
	mov rax, rcx
	sub rax, r8
	cmp rax, 4
	jl subtraction_scalar_cleanup
	vmovdqu ymm0, [rdi]
	vmovdqu ymm1, [rsi]
	vpsubq ymm2, ymm0, ymm1
	vmovdqu [rdx], ymm2
	add r8, 4
	add rdi, 32
	add rsi, 32
	add rdx, 32
	cmp r8, rcx
	jl simd_subtraction_loop

subtraction_scalar_cleanup:
	cmp r8, rcx
	jge sub_scalar_done
	mov rax, [rdi]
	sub rax, [rsi]
	mov [rdx], rax
	add rdi, 8
	add rsi, 8
	add rdx, 8
	jmp subtraction_scalar_cleanup

sub_scalar_done:
	ret
