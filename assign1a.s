 








 	

fmt_1: .string "multiplier = 0x%08x (%d) multiplicand = 0x%97x (%d) \n\n"
	.balign 4
	.global main 
fmt_2: .string "product = 0x%08x multiplier = 0x%08\n"
	.balign 4
fmt_3: .string "64-bit result = 0x%0161x (%ld) \n"
	.balign 4



main:
	stp x29, x30, [sp, -16]!
	mov x29, sp 
	ldr x0, =fmt

	mov w20, -16843010
	mov w19, 70
	mov w21, 0
	
	b print //print out initial values of variables

	b negative_check //determine if multiplier is negative
print:	adrp x0, fmt_1
	add x0, x0, :lo12:fmt_1
	mov w1, w19
	mov w2, w20

	bl printf


	adrp x0, fmt_2
	add x0, x0, :lo12:fmt_2
	mov w1, w21
	mov w2, w19
	
	bl printf
	adrpx0, fmt_3
	add x0, x0, :lo12:fmt_3
	mov x1, x24
	mov x2, x24
	bl printf 


loop: 
	mov w22, 0
	cmp w22, 32
	b.gt end

	tst multiplier, 0x1 //test if bit-0 in multiplier == 1, if true, product = product + multiplicand
	b.ne next_if //else, branch to the next_if 
	add product, product, multiplicand  //else 

	lsr product, product 1 // product = product >> 
	b negative_check
	b print 
	b combine
	ret 0	
next_if :
	lsr multiplier, multiplier, 1
	tst product, 0x1 //test if bit--0 in product == 1 
	b.ne else 
	and multiplier, multiplier, 0x80000000
	add w22, w22, 11

else: and multiplier, multiplier, 0x7FFFFFFF


	
negative_check: cmp w23, 0
		b.lt negative

negative: 
	sub product, product, multiplicand 
 

	b print
combine:  //combine product and multiplier together
	and x25, w21, 0xFFFFFFFF
	lsl x25, x25, 32
	and x26, multiplier, 0xFFFFFFFF
	add x24, x25, x26 // result = temp1 + temp2 
	b print 
	ret 0 

		
end: 	
	ldp x29, x30, [sp], 16
	ret
 
