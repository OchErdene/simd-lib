section .text 
	global add
	global multiply
	global subtract
	global divide
	global add_arrays
	global simd_add_arrays

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
	jl division_done
	sub rcx, rsi
	add rax, 1
	jmp division_loop

division_done:
	ret

add_arrays:
	mov r8, 0

array_loop:
	mov rax, [rdi]
	add rax, [rsi]
	mov [rdx], rax
	add r8, 1
	add rdi, 8
	add rsi, 8
	add rdx, 8
	cmp r8, rcx
	jl array_loop
	ret

simd_add_arrays:
	vmovdqu ymm0, [rdi]
	vmovdqu ymm1, [rsi]
	vpaddq ymm2, ymm0, ymm1
	vmovdqu [rdx], ymm2
	ret
