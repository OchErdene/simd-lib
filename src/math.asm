section .text 
	global add
	global multiply
	global subtract
	global divide
	global add_arrays
	global simd_add_arrays
	global subtract_arrays
	global simd_subtract_arrays
	global dot_product
	global simd_dot_product

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

dot_product:
	mov r8, 0
	vxorpd xmm0, xmm0, xmm0 ; xmm0 = 0, rax is integer hence cant handle double so xmm
				; is the register you have to work with

dot_product_loop:
	movsd xmm1, [rdi]
	mulsd xmm1, [rsi]
	addsd xmm0, xmm1
	add rsi, 8
	add rdi, 8
	add r8, 1
	cmp r8, rdx
	jl dot_product_loop
	ret

simd_dot_product:
	mov r8, rdx
	vxorpd ymm3, ymm3, ymm3
	vxorpd xmm4, xmm4, xmm4

simd_dot_product_loop:
	cmp r8, 4
	jl simd_dot_cleanup
	vmovupd ymm0, [rdi]
	vmovupd ymm1, [rsi]
	vmulpd ymm2, ymm0, ymm1
	vaddpd ymm3, ymm3, ymm2
	add rdi, 32
	add rsi, 32
	sub r8, 4
	jg simd_dot_product_loop

simd_dot_cleanup:
	cmp r8, 0
	jle simd_dot_done
	vmovsd xmm0, [rdi]
	vmovsd xmm1, [rsi]
	vmulsd xmm0, xmm0, xmm1
	vaddsd xmm4, xmm4, xmm0
	add rsi, 8
	add rdi, 8
	sub r8, 1
	jmp simd_dot_cleanup

simd_dot_done:
	vextracti128 xmm1, ymm3, 1
	vaddpd xmm0, xmm3, xmm1
	vunpckhpd xmm1, xmm0, xmm0
	vaddsd xmm0, xmm0, xmm1
	vaddsd xmm0, xmm0, xmm4
	ret
