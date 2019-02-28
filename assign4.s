/**
Mila Hoogstraat
ID : 30055558
Assignment 3
Lecture 01
**/

//equates for dimension
width_s = 0 //offset for width 
height_s = 4 //offset for height 
dim_size = 4 //offset for dimension

//equates for a point
point: 
	x_s = 0 //setting offset of x to 0 
	y_s = 4 //offset of x is 0, so offset of y must be 4
	point_size = 4 //size of point structure 

//equates for box (nested struture)
box: 
	area_s = 0 //offset for box's area 
	origin_s = 4 //offset for box's origin
	size_s = 16 //offset for box's size
	box_size = 20

//function: new_box
b_size = 20
alloc = -(16 + b_size) & -16
dealloc = -alloc 
n_s = 16 //offset for new structure 



new_box: 
	stp x29, x30, [sp, alloc]! //store frame pointer and local register to the stack 
	mov x29, sp  //updates the FP register to the current SP register
	mov w19, 1 //mov int 1 to register w19

	str wzr, [x29, n_s + origin_s + x_s] //b.origin.x = 0
	str wzr, [x29, n_s + origin_s + y_s] //b.origin.y = 0

	str w19, [x29, n_s + size_s + width_s] //b.size.width = 1
	str w19, [x29, n_s + size_s + height_s] //b.size.height = 1
	ldr w20, [x29, n_s + size_s + width_s] //load value of b.size.width onto w20 register
        ldr w21, [x29, n_s + size_s + height_s] //load value of b.size.height onto w21 register

        mul w22, w20, w21 //load value of b.size.width * b.size.height onto register w21
       // str w22, [x29, area_s] //init area to b.size.width * b.size.height
        str w22, [x29, n_s + area_s] //b.area = b.size.width * b.size.height
	//return b.area
	ldr w9, [x29, n_s + area_s] //use w9 register to load structure's area
	str w9, [x8, area_s]  //store current value of structure's area
	//return b.origin.x
	ldr w9, [x29, n_s + origin_s + x_s] //use w9 temp register to load structure's x origin
	str w9, [x8, origin_s + x_s] //store current value of structure's x origin
	//return b.origin.y
	ldr w9, [x29, n_s + origin_s + y_s] //use w9 temp register to load structure's y origin
	str w9, [x8, origin_s + y_s] //store current value of structure's y origin


	//return b.size.width
	ldr x9, [x29, n_s + size_s + width_s] //use w9 register to load structure's width
	str x9, [x8, size_s + width_s] //store current value of b.size.width 
	//return b.size.height
	ldr x9, [x29, n_s + size_s + height_s] //use w9 reister to load structure's height
	str x9, [x8, size_s + height_s] //store current value of b.size.height
	

	ldp x29, x30, [sp], dealloc //restores state
	ret //return to caller

initial_box: .string "Initial box values: \n" //create format string to print "Initial box values:" 
changed_box: .string "\nChanged box values:\n" //create format string to print "Changed box values:"

printBox: 
	.string "Box %d origin = (%d, %d) width = %d height = %d  area = %d \n" //create format string to print box values 
	.balign 4 //pads the location counter to ensure the instructions are aligned properly

print_boxes:
	
	stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack
	mov x29, sp //updates the FP register to the current SP register 

	mov w1, w19 //move value of w19 register (1) onto w1 register
	ldr w2, [x0, origin_s + x_s] //load b.origin.x onto w2 register
	ldr w3, [x0, origin_s + y_s] //load b.origin.y onto w3 register
	ldr w4, [x0, size_s + width_s] //load b.size.width onto w4 register
	ldr w5, [x0, size_s + height_s] //load b.size.height onto w5 register
	ldr w6, [x0, area_s] //load b.area onto w6 register

	adrp x0, printBox //reserves the x0 register as first argument for printf
	add x0, x0, :lo12:printBox //adding low 12 bits to the x0 register
	bl printf //branch & link instruction to printf

	ldp x29, x30, [sp], 16 //restores state
	ret //returns to the caller 


changed_print: //function to print the changed box values 

        adrp x0, changed_box //reserves x0 register as first argument for printf
        add x0, x0, :lo12:changed_box //adding low 12 bits to the x0 register
        bl printf //print "Changed box values:" //branch & link instruction to printf
	
	
	add x0, x29, box1_s //initiate first box 
        mov w19, 1 //mov int value 1 into register w19
        bl print_boxes //branch & link instruction to print_boxes

        add x0, x29, box2_s //initiate second box 
        mov w19, 2 //mov int value 2 into register w19
        bl print_boxes //branch & link instruction to print_boxes

	ldp x29, x30, [sp],main_dealloc //restores state
 	ret //returns to caller 

 
 
//function : move
deltaX_s = 20 //offset for deltaX
deltaY_s = 24 //offset for deltaY

deltaX_size = 4 //size of int deltaX is 4 bytes 
deltaY_size = 4 //size of int deltaY is 4 bytes

move:

	stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack
	mov x29, x30 //updates the FP register to the current SP register

	ldr w9, [x0, origin_s + x_s]  //get value of box1's x origin
	add w9, w9, w19 //b.origin.x +=  -5
	str w9, [x0, origin_s + x_s] //store new value of b.origin.x on temp register w9
	

	ldr w9, [x0, origin_s + y_s] //load value of box1's y origin onto w9 register 
	add w9, w9, w20 //b.origin.y += 7
	str w9, [x0, origin_s + y_s] //store new value of b.origin.y on temp register w9

	ldp x29, x30, [sp], 16 //restores state
	ret //returns to caller 

//function: expand
factor_s = 28 //offset for factor
factor_size = 4 //size of int factor is 4 bytes 

expand: 
	stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack
	mov x29, x30 //updates the FP register to the current SP register 

	
	
	ldr w9, [x1, size_s + width_s]//load w9 register with current value of box2's width
	mul w9, w9, w19 //b.size.width *= 3(factor)
	str w9, [x1, size_s + width_s] // store current value of b.size.width on temp register w9

	ldr w10, [x1, size_s + height_s] //get value of box2.size.height
	mul w10, w10, w19 //size.heigh *= 3 (factor)
	str w10, [x1, size_s + height_s] //store current value of b.size.height on temp register w9
 
	mul w11, w9, w10  //store value of b.size.width * b.size.height onto temp register w11
	str w11, [x1, area_s] //store product into b.area on temp register w11
	
	ldp x29, x30, [sp], 16 //restores state
	ret //returns to caller

	


//function: equal
false = 0 //setting false to int 0 
true = 1 //setting true to int 1
 
equal:	
	stp x29, x30, [sp,-16]! //store frame pointer and local register to the stack 
	mov x29, x30 //updates the FP register to the current SP register 
	
	 //setting macro for w23 
	mov w23, false //w23 = false 

	ldr w9, [x0, origin_s + x_s] //load value of box1's x origin onto temp register w9
        ldr w10, [x1, origin_s + x_s] //load value of box2's x origin onto temp register w10
        cmp w9, w10 //compare box1's x origin with box2's x origin
        b.ne changed_print //if origin's are not equal, branch to changed_print
	
	ldr w9, [x0, origin_s + y_s] //load value of box1's y origin onto temp register w9
	ldr w10, [x1, origin_s + y_s] //load value of box2's y origin onto temp register w10
	cmp w9, w10 //compare the y origins of the boxes
	b.ne changed_print //if origins are not equal, branch to changed_print
	
	ldr w9, [x0, size_s + width_s] //load value of box1's width onto temp register w9
	ldr w10, [x1, size_s + width_s] //load value of box2's width onto temp register w10
	cmp w9, w10 //compare the widths of the boxes
	b.ne changed_print //if widths are not equal, branch to changed_print
	
	ldr w9, [x0, size_s + height_s] //load value of box1's height onto temp register w9
	ldr w10, [x1, size_s + height_s] //load value of box2's height onto temp register w10
	cmp w9, w10 //compare the heights of the boxes
	b.ne changed_print //if heights are not equal, branch to changed_print

	mov w23, true //if heights are equal, w23 = true 


end:	
	ldp x29, x30, [sp],16 //restore state
	ret //returns to caller
	

//function: main
box1_s = 16 //offset for first box
box2_s = box1_s + box_size //offsent for second box
 
variable_size = deltaX_size + deltaY_size + factor_size + box_size*2 //calculating total space needed for variables

main_alloc = -(16 + variable_size) & -16 //allocate
main_dealloc = -alloc //deallocate

.global main //making main function visible to the OS

main: 
	stp x29, x30, [sp, main_alloc]! //store frame pointer and local register to the stack 
	mov x29, sp //updates the FP register to the current SP register
	
	add x8, x29, box1_s //calculate base address of first box
	bl new_box //branch & link isntruction to new_box
	add x8, x29, box2_s //calcualte base address of second box
	bl new_box //branch & link instruction to new_box

//	print initial box values 
	adrp x0, initial_box //reserves the x0 register as first argument for printf
	add x0, x0, :lo12:initial_box //adding low 12 bits to the x0 regsiter 
	bl printf //print "Initial box values:"
	
	add x0, x29, box1_s //use x0 register to pass in first box's structure into print_boxes function 
	mov w19, 1 //moving int value 1 into w19 register
	bl print_boxes //branch & link instruction to print_boxes
	
	add x0, x29, box2_s //use x0 register to pass in second box's structur e into print_boxes function 
	mov w19, 2 //moving int value 2 into w19 register
	bl print_boxes //branch & link instruction to print_boxes
	 
	 	
	add x0, x29, box1_s //use x0 register to pass first box's structure into equal function
	add x1, x29, box2_s //use x1 register to pass second box's structure into equal function 
	bl equal //branch & link instruction to equal function
	
	cmp w23, true //check if w23 == true

	b.ne changed_print //if w23 == false branch to changed_print to print changed box values
	//if all attributes of both boxes are the same, set up variables for move function 
	add x0, x29, box1_s //use x0 register to pass first box's structure into move function
	mov w19, -5 //setting deltaX to -5 to be used in  move function 
       	mov w20, 7 //setting deltaY to 7 to be used in move function

        bl move //branch & link instruction to move function
	add x0, x29, box2_s //use x0 register to pass second box's structure into move function
	mov w19, 3 //set factor to 3 to be used in expand function 
	bl expand //branch & link instruction to expand funciton 
	
	bl changed_print //branch & link instruction to changed_print function 
	
	ldp x29, x30, [sp],main_dealloc //restores state
	ret //return to caller  
