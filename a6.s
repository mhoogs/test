/**
Mila Hoogstraat
ID: 30055558
Assignment 6
Lecture 01
***/


decimal_m: .double 0r1.0e-10 //1.0 e^-10
AT_FDCWD = -100 //pathname is relative to the program's cwd

in: .string "input.bin" //name of file 
err: .string "Error opening file: %s\n" //prints when opening file is unsuccessful
col_header: .string " Input:                  Cube root:\n"             //header for output columns
fmt: .string "%13.10f     %19.10f\n" //prints input and cubed root values 
input_print: .string "%13.10f\n" //
cube_print: .string "%20.10f\n"
end_file: .string "End of file has been reached.\n" //prints when end of file is reached 
	.balign 4 //pads the location counter to ensure the instructions are properly aligned 
	.global main //makes main function visible to the OS 

buf_size = 8 //buffer size is 8 bytes
buf_s = 16 //stack offset of buffer

//define equates for stack aliases
alloc = (-16 + buf_size) & -16 //allocate
dealloc = -alloc //deallocate


main: 
	stp x29, x30, [sp,alloc]! //store frame pointer and local register to the stack 
	mov x29,sp //updates the FP register to the current SP register 

	mov w0, AT_FDCWD //1st argument : using cwd
	adrp x1, in //2nd argument: path name 
	add x1, x1,:lo12:in //adding low 12 bits to x1 register 
	
	mov w2, 0 //third argument: read-only
	mov w3, 0 //4th argument : not used

	mov x8, 56 //service request: openat
	svc 	0  //call system function 
	mov w19, w0 //record file descriptor
	cmp w19, 0 //check if file opened by check if size read is greater or equal to 0 
	b.ge open_ok //if yes, branch to open_ok

	//if file did not open, print error message and end 
	adrp x0, err //reserving x0 register for first argument of printf
	add x0, x0, :lo12:err //adding low 12 bits to x0 register 
	adrp x1, in //reserving x1 register 
	add x1, x1, :lo12:in //adding low 12 bits to x1 register 
	
	bl printf //branch and link instruction to printf
	mov w0, -1 //return value: -1
	bl end //branch to end 

open_ok: //if file opened 
	
	adrp x0, col_header //reserve x0 register for printf
	add x0, x0, :lo12:col_header //adding low 12 bits to x0 register
	bl printf //branch & link instruction to printf 
	
	add x21, x29, buf_s  //calculate the buf base 

loop:
	mov w0, w19 //first argument: fd
	mov x1, x21 //second argument: buf
	mov w2, buf_size //third argument: n 
	mov x8, 63 //service request: read
	svc 0 //call system function 

	mov x20, x0 //move number of bytes read onto x20 register

	cmp x20, buf_size  //check number of bytes read 
	b.ne end_err //if bytes read is not 8, then it is end of file. branch to

	ldr d0, [x21] //load value of input onto d0 register
	bl cube_root //branch to cube_root

	adrp x0, fmt //reserve x0 register as first argument for printf
        add x0, x0, :lo12:fmt //adding low 12 bits to the x0 register
	ldr d0, [x21] //load value of input onto d0 register
	fmov d1, d2 //move value of x onto d1 register
      
        bl printf //branch & link instruction to printf
	bl loop  //branch to loop 

cube_root: //first part of cube rooting the input value 
	fmov d1, 3.0 //move 3.0 onto d1 register
	fdiv d2, d0, d1 //x= input/3.0 

cube_root_2: //second part of cube rooting the input value 
	fmul d3, d2, d2 //store y= x * x onto d3 register
	fmul d3, d3, d2 //store y= x*x*x onto d3 register

	fsub d4, d3, d0 //dy = y - input on d4 register 
	fmul d5, d1, d2 //dy/dx = 3.0*x
	fmul d5, d5, d2 //dy/dx = 3.0*x*x

	fdiv d6, d4, d5 //dy/(dy/dx)
	fsub d2, d2, d6 //x - dy/(dy/dx)
	
	fabs d7, d4 //store |dy| onto d7
	
	adrp x22, decimal_m //getting address of decimal_m
	add x22, x22, :lo12:decimal_m //add low 12 bits onto x22 register 
	ldr d8, [x22] //load value of decimal_m onto d8
	ldr d0, [x21] //load value of input onto d0 register

	fmul d9, d0, d8 //input * constant onto d9 register
	
	fcmp d7, d9 //compare |dy| with input*constant

	b.ge cube_root_2 //if |dy| >= input*constant branch to cube_root_2
	ret //return 

end_err: //prints error message when end of file is reached
	adrp x0, end_file //reserve x0 register as first argument for printf
	add x0, x0, :lo12:end_file //adding low 12 bits to x0 register
	bl printf //branch & link instruction to printf
	bl end  //branch to end 
	
end:
	//closing file
	mov w0, w19 //move first argument (fd) onto w0 register 
	mov x8, 57 //service request: close 
	svc 0 //call function/closing the file 

	//exiting 
	ldp x29, x30, [sp], dealloc //restore state
	ret //return to caller	
