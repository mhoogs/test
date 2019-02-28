/**
Assignment 2a
Name: Mila Hoogstraat
UCID: 30055558
CPSC 355
Lecture 02
*/

//defining macros 
define(multiplier_r, w19) //instructing multiplier_r macro to expand to the w19 register
define(multiplicand_r, w20) //instructing the multiplicand_r macro to expand to the w20 register
define(product_r, w21) //instructing the product_r macro to expand to the w21 register

define(i_r, w22) //instructing i_r macro to expand to the w22 register
define(negative_r, w23) //instructing negative_r macro to expand to the w23 register
define(true, w24) //instructing true macro to expand to the w24 register
define(false, w25) //instructing false macro to expand to the w25 

//64-bit registers 
define(result_r, x24) //instructing result_r macro to expand to the x24 register
define(temp1_r, x25) //instructing temp1_r macro to expand to the x25 register
define(temp2_r, x26) //instructing temp2_r macro to expand to the x26 register
 	
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
	
	mov multiplicand_r, -16843010 //setting the multiplicand to integer -16843010
	mov multiplier_r, 70 //setting the multiplier to integer 70
	mov product_r, 0 //setting the initial product value to integer 0
	mov i_r, 0 //initiating i by setting it to integer 0
	mov negative_r, 0 //initiating negative value by setting it to integer 0(false)

	adrp x0, fmt_1 //reserves x0 register as first argument for printf
	add x0,x0, :lo12:fmt_1 //adding low 12 bits to the x0 register

	mov w1, multiplier_r //moving current value of the multiplier to the w1 register (hexadecimal form)
	mov w2, multiplier_r //moving current value of the multiplier to the w2 register (decimal form)

	mov w3, multiplicand_r //moving current value of the multiplicand  to the w3 register (hexadeximal form)
	mov w4, multiplicand_r //moving current value of the multiplicand to the w4 register (decimal form)
	bl printf //branch and link instruction to printf()
 
	b check_negative //branch to check_negative to check if multiplier is negative


 	

product_print: //prints the product and multiplier
	adrp x0, fmt_2 //reserves x0 register as first argument for printf
	add x0, x0, :lo12:fmt_2 //adding low 12 bits to the x0 register
	mov w1, product_r //moving current value of the product to the w1 register (hexadecimal form)
	mov w2, multiplier_r //moving current value of the multiplier to the w2 register (hexadecimal form)
	
	bl printf //branch and instruction to printf()
	
	b combine //branch to combine to combine the product and multiplier together


	
loop: //for loop 
	
	
	tst multiplier_r,0x1 //test if bit-0 in multiplier_r == 1
	b.eq  next_if //if true, branch to next_if
	add product_r, product_r, multiplicand_r //product = product + multiplicand 
	b next_if //branch to next_if 

next_if:
	asr multiplier_r, multiplier_r, 1 //arithmetic shift right : multiplier = multiplier >> 1
	tst product_r, 0x1 //test if bit-0 in product_r ==1  
	b.eq else //if true, branch to else 
	orr multiplier_r, multiplier_r, 0x80000000 //multiplier_r = multiplier_r | 0x80000000 
	asr product_r, product_r, 1 //arithmetic shift right : product = product >> 1
	add i_r, i_r, 1 //increment i by 1
	
	b test //branch to pre-test loop


else: 
	and multiplier_r, multiplier_r, 0x7FFFFFFF //multiplier_r = multiplier_r & 0x7FFFFFFF
	asr product_r, product_r, 1 //arithmetic shift right: product = product >> 1
	add i_r, i_r, 1 //increment i by 1
 
	b test //branch to pre-test loop
 
check_negative: 
	cmp multiplier_r, 0 //check if multiplier is negative
	b.lt negative //branch to negative 
	mov negative_r, 0 //if multiplier is not negative, set negative_r, to 0 (false)
	b test //branch back to the pre-test loop 
	
check_negative_2: //adjust product register if multiplier is negative 
	cmp negative_r, 1 //check if multiplier is negative 
	b.ne product_print //if not, banch to print_2

	sub product_r, product_r, multiplicand_r  //product = product - multiplicand 		
	b product_print  //branch back to print_2
negative: 
	mov negative_r, 1 //set value of negative_r to 1 (true)
	b test //branch back to pre-test loop

test: cmp i_r, 32 //compare it to integer 32
	b.lt loop //if i<32, branch to loop
	b product_print //print the product and multiplier	

combine: //combine product and multiplier together  
	sxtw temp1_r, product_r //sign-extends bit 31 to bits 32-64
	and temp1_r, temp1_r, 0xFFFFFFFF //temp1_r = (long int)product_r & 0xFFFFFFFF
	lsl temp1_r, temp1_r, 32 //logic shift left: temp1_r = temp1_r << 32

	sxtw temp2_r, multiplier_r //sign-extends bit 31 to bits 32-64
	and temp2_r, temp2_r, 0xFFFFFFFF //temp2_r = (long int)multiplier_r & 0xFFFFFFFF

	add result_r, temp1_r, temp2_r // result = temp1 + temp2   
	
	adrp x0, fmt_3 //reserves x0 register as first argument for printf
	add x0, x0, :lo12:fmt_3 //adding low 12 bits to the x0 register
	mov x1, result_r //moving current value of the result to the x1 register (hexadecimal form)
	mov x2, result_r //moving current value of the result to the x2 register (decimal form)
	
	bl printf //branch and instruction to printf()
	

	
end: 	
	ldp x29, x30, [sp], 16			// restores state
		ret					// return to the caller 
 
