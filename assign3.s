/***** 
Mila Hoogstraat
ID: 30055558
LEC 01
Assignment 3
*******/

size = 50 //set number of elements in the array to 50
array_size = size * 4 //allocating 4 bytes for every element in the array
array_s = 16 //stack offset of array
j_s = array_s + array_size //stack offset of j 
i_s = array_s + array_size //stack offset of i
temp_s = i_s + i_size //stack offset of temp
temp2_s = i_s + i_size //stack offset of temp2
temp3_s = i_s + i_size //stack offset of temp3
 
i_size = 4 //size of i is 4 bytes
j_size = 4 //size of j is 4 bytes
temp_size = 4 //size of temp is 4 bytes 
temp2_size = 4 //size of temp2 is 4 bytes
temp3_size = 4 //size of temp3 is 4 bytes
 
var_size = array_size + i_size + j_size + temp2_size + temp_size //total memory needed to allocate and deallocate

//define equates for stack aliases
alloc = -(16 + var_size) & -16 //allocate 
dealloc = -alloc //deallocate
 
//define register aliases
fp 	.req x29
lr 	.req x30

print_sorted: .string "\nSorted array:\n" //create format string to print "Sorted array:"

fmt:
	.string "v[%d]: %d\n" //create format string to print the array values
	.balign 4 //pads the location counter to ensure the instructions are algined properly
	.global main //makes main function visible to the OS


main:
        stp fp, lr, [sp, alloc]! //store frame pointer and local register to the stack
        mov fp, sp //updates the FP register to the current sp register
	mov w19, 0 //set i to int 0
	str w19, [x29, i_s] //store current value of i 
	mov w20, 0 //set j to int 0
	str w20, [x29, j_s] //store current value of j 
	b test_1 //branch to ipre-test loop for loop_1


loop_1: //first for loop
	ldr w19, [fp, i_s] //reading index i 
	bl rand //generating a random integer
	and w22, w0, 0xFF  //mod 256
	add x24, fp, array_s //calculate array base address
	str w22, [x24, w19, sxtw 2] //storing rand * 0xFF at v[i]
	
	adrp x0, fmt //reserves x0 register as first argument for printf
	add w0, w0, :lo12:fmt //adding low 12 bits to the x0 register
	mov w1, w19 //moving current value of i to the w1 register
	ldr w23, [x24, w19, sxtw 2] //get value of v[i]
	mov w2, w23 //move the value v[i] to the w2 register
	bl printf //branch and link function to printf()
	
	ldr w19, [fp, i_s] //get index i 
	add w19, w19, 1 //increment i by 1
	str w19, [fp, i_s] //store new i value 

test_1: //pre-test loop for loop_1
        cmp w19, size //compare i with size value
        b.lt loop_1 //is i < size? if yes, begin loop_1
        mov w19, 1 //if i >= size, re-initialize i to 1 for the second for loop
        str w19, [fp, i_s] //store the current value of i
        b test_2 //branch to test_2
	

loop_2: //second for loop (outer loop of sort)
	
	add x24, fp, array_s //calculate array base address
	ldr w27, [x24, w19, sxtw 2] //read current value of v[i]
	ldr w21, [fp, temp_s] //read the value of temp
	mov w21, w27 //temp= v[i]
	str w21, [fp, temp_s] //store new value of temp variable	
	mov w20, w19 // j =i
	str w20, [fp, i_s] //store current value of i
	b check_1 //branch to check first condition of loop 
	

test_2: //pre-test loop for loop_2
	cmp w19, size //compare the value of i with the value of size
	b.ge print_1 //if i>= size? if yes, skip to print_1
	b loop_2 //if i<size, enter the second for loop


loop_3: //inner loop of loop_2 (sort)
	add x24, fp, array_s //calculate array base address
	ldr w20, [fp, j_s] //get value of j
	ldr w28, [fp, temp3_s] //get value of temp3
	sub w28, w20, 1 // temp3 = j-1
	ldr w26, [x24, w25, sxtw 2] //other temp = v[j-1]
	str w26, [x24, w20, sxtw 2] //v[j] = v[j-1]
	sub w20, w20, 1 //j--
	str w20, [fp, j_s] //store current value of j 
	b check_1 //check the first condition of the inner loop


check_1: //checks the first condition of the inner loop (pre-test loop for loop_3 #1)
        cmp w20, 0 //compare value of j with int 0
        b.le store_temp //if j<=0 then branch to store_temp
        b check_2 //if j>0, branch to check next condition


check_2: //checks the second condition of the inner loop (pre-test loop for loop_3 #2)
        add x24, fp, array_s //calculate array base address
        ldr w25, [fp, temp2_s] //read value of temp2_r variable from the stack
        ldr w20, [fp, j_s] //get current j value
        sub w25, w20, 1 //temp2 = j-1
        ldr w26, [x24, w25, sxtw 2] // reading value v[j-1] and assigning it to a temporary register
        cmp w21, w26 //compare temp and v[j-1] values
        b.lt loop_3 //if temp < v[j-1], enter the nested loop (loop_3)
        b store_temp //branch to store_temp

store_temp: //v[j] = temp
	str w21, [x24, w20, sxtw 2] // store value of temp into v[j]
	add w19, w19, 1 //iterate through loop by i++
	b test_2 //branch back and check condition of outer loop
	
print_1: 
	adrp x0, print_sorted //reserves the x0 register as first argument for printf
	add w0, w0, :lo12:print_sorted //adding low 12 bits to the x0 register
	mov w1, 0 //move int 0 to the w1 register
	bl printf //branch and link instruction to print
	
	mov w19, 0 //reset i value to 0 
	str w19, [x29, i_s] //store current of i
	cmp w19, size //compare i with size
	b.lt loop_4 //if i<size print

		
loop_4: //the printing loop
	adrp x0, fmt //reserves x0 register as first argument for printf 
	add w0, w0, :lo12:fmt //adding low 12 bits to the x0 register
	mov w1, w19 //moving current value of i to the w1 register
	ldr w27, [x24, w19, sxtw 2] //get the current value of v[i]
	mov w2, w27  //move the current value of v[i] to the w2 register
	bl printf //branch and link instruction to print

	add w19, w19, 1 //increment i by 1
	str w19, [fp, i_s] //store current value of i
	b test_4 //branch back to test_5

test_4: 
	cmp w19, size //compare i with size
        b.lt loop_4 //if i<size, branch to loop_4
        b end //if i>= size, branch to end

end: 
	mov w0, 0 //mov int 0 to the w0 register
	ldp fp, lr, [sp], dealloc //restores state
	ret //returns 0 to the caller
