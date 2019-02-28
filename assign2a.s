/**
Assignment 2a
Name: Mila Hoogstraat
UCID: 30055558
CPSC 355
Lecture 02
**/

//defining macros 
 //instructing w19 macro to expand to the w19 register
 //instructing the w20 macro to expand to the w20 register
 //instructing the w21 macro to expand to the w21 register

 //instructing w22 macro to expand to the w22 register
 //instructing w23 macro to expand to the w23 register
 //instructing w24 macro to expand to the w24 register
 //instructing w25 macro to expand to the w25 

//64-bit registers 
 //instructing x24 macro to expand to the x24 register
 //instructing x25 macro to expand to the x25 register
 //instructing x26 macro to expand to the x26 register
 	
.global main //makes the "main" function visible to the OS

//creating the format strings
fmt_1: .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d) \n\n" //creates the format string to print the intial values
	.balign 4 //pads the location counter to ensure the instructions are aligned properly 

	 
fmt_2: .string "product = 0x%08x  multiplier = 0x%08x\n" //creates the format string to print out the product and multiplier
	.balign 4 //pads the location counter to ensure the instructions are aligned properly

fmt_3: .string "64-bit result = 0x%016lx (%ld) \n" //creates the format string for printing out the 64-bit result
	.balign 4
               


main: //main function
	stp x29, x30, [sp, -16]! //saves the state
	mov x29, sp //updates the FP register to the current SP register
	
	mov w20, -16843010 //setting the multiplicand to integer -16843010
	mov w19, 70 //setting the multiplier to integer 70
	mov w21, 0 //setting the initial product value to integer 0
	mov w22, 0 //initiating i by setting it to integer 0
	mov w23, 0 //initiating negative value by setting it to integer 0(w25)

	adrp x0, fmt_1 //reserves x0 register as first argument for printf
	add x0,x0, :lo12:fmt_1 //adding low 12 bits to the x0 register

	mov w1, w19 //moving current value of the multiplier to the w1 register (hexadecimal form)
	mov w2, w19 //moving current value of the multiplier to the w2 register (decimal form)

	mov w3, w20 //moving current value of the multiplicand  to the w3 register (hexadeximal form)
	mov w4, w20 //moving current value of the multiplicand to the w4 register (decimal form)
	bl printf //branch and link instruction to printf()
 
	b check_negative //branch to check_negative to check if multiplier is negative


 	

product_print: //prints the product and multiplier
	adrp x0, fmt_2 //reserves x0 register as first argument for printf
	add x0, x0, :lo12:fmt_2 //adding low 12 bits to the x0 register
	mov w1, w21 //moving current value of the product to the w1 register (hexadecimal form)
	mov w2, w19 //moving current value of the multiplier to the w2 register (hexadecimal form)
	
	bl printf //branch and instruction to printf()
	
	b combine //branch to combine to combine the product and multiplier together


	
loop: //for loop 
	
	
	tst w19,0x1 //test if bit-0 in w19 == 1
	b.eq  next_if //if w24, branch to next_if
	add w21, w21, w20 //product = product + multiplicand 
	b next_if //branch to next_if 

next_if:
	asr w19, w19, 1 //arithmetic shift right : multiplier = multiplier >> 1
	tst w21, 0x1 //test if bit-0 in w21 ==1  
	b.eq else //if w24, branch to else 
	orr w19, w19, 0x80000000 //w19 = w19 | 0x80000000 
	asr w21, w21, 1 //arithmetic shift right : product = product >> 1
	add w22, w22, 1 //increment i by 1
	
	b test //branch to pre-test loop


else: 
	and w19, w19, 0x7FFFFFFF //w19 = w19 & 0x7FFFFFFF
	asr w21, w21, 1 //arithmetic shift right: product = product >> 1
	add w22, w22, 1 //increment i by 1
 
	b test //branch to pre-test loop
 
check_negative: 
	cmp w19, 0 //check if multiplier is negative
	b.lt negative //branch to negative 
	mov w23, 0 //if multiplier is not negative, set w23, to 0 (w25)
	b test //branch back to the pre-test loop 
	
check_negative_2: //adjust product register if multiplier is negative 
	cmp w23, 1 //check if multiplier is negative 
	b.ne product_print //if not, banch to print_2

	sub w21, w21, w20  //product = product - multiplicand 		
	b product_print  //branch back to print_2
negative: 
	mov w23, 1 //set value of w23 to 1 (w24)
	b test //branch back to pre-test loop

test: cmp w22, 32 //compare it to integer 32
	b.lt loop //if i<32, branch to loop
	b product_print //print the product and multiplier	

combine: //combine product and multiplier together  
	sxtw x25, w21 //sign-extends bit 31 to bits 32-64
	and x25, x25, 0xFFFFFFFF //x25 = (long int)w21 & 0xFFFFFFFF
	lsl x25, x25, 32 //logic shift left: x25 = x25 << 32

	sxtw x26, w19 //sign-extends bit 31 to bits 32-64
	and x26, x26, 0xFFFFFFFF //x26 = (long int)w19 & 0xFFFFFFFF

	add x24, x25, x26 // result = temp1 + temp2   
	
	adrp x0, fmt_3 //reserves x0 register as first argument for printf
	add x0, x0, :lo12:fmt_3 //adding low 12 bits to the x0 register
	mov x1, x24 //moving current value of the result to the x1 register (hexadecimal form)
	mov x2, x24 //moving current value of the result to the x2 register (decimal form)
	
	bl printf //branch and instruction to printf()
	

	
end: 	
	ldp x29, x30, [sp], 16			// restores state
		ret					// return to the caller 
 
