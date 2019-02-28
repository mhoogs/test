/****
Mila Hoogstraat
ID: 30055558
LEC 01
Assignment 3
*******/

size = 50 //set number of elements in the array to 50
array_size = size * 4 //allocating 4 bytes for every element in the array
i_size = 4
j_size = 4
j_s = array_s + array_size
i_s = array_s + array_size
temp_s = i_s + i_size
temp2_s = i_s + i_size
j_size = 4
temp_size = 4
temp2_size = 4
array_s = 16
temp3_s = i_s + i_size
var_size = array_size + i_size + j_size + temp2_size + temp_size //total memory needed for local variables
alloc = -(16 + var_size) & -16
dealloc = -alloc
print_sorted: .string "\nSorted array:\n"
fmt: .string "v[%d]: %d\n"

.balign 4
.global main


main:
        stp x29, x30, [sp, alloc]! //store frame pointer and local register to the stack
        mov x29, sp
        mov w19, 0 //set i to int 0
        str w19, [x29, i_s] //store current value of i
        mov w20, 0 //set j to int 0
        str w20, [x29, j_s]
        mov w21, 0 //set temp to int 0
        str w21, [x29, temp_s]
        mov w25, 0
        str w25, [x29, temp2_s]
        add x24, x29, array_s //calculate array base address
        b test_1


loop_1:
        ldr w19, [x29, i_s] //reading index i
        bl rand //generating a random integer
        and w22, w0, 0xFF  //mod 256
        add x24, x29, array_s //calculate array base address
        str w22, [x24, w19, sxtw 2] //storing rand * 0xFF at v[i]

        adrp x0, fmt
        add w0, w0, :lo12:fmt
        mov w1, w19
        ldr w23, [x24, w19, sxtw 2]
        mov w2, w23
        bl printf


        ldr w19, [x29, i_s] //get index i
        add w19, w19, 1 //increment i by 1
        str w19, [x29, i_s] //store new i value



        b test_1

loop_2:



//      ldr w19, [x29, i_s] //readindex from the stack
        add x24, x29, array_s
        ldr w27, [x24, w19, sxtw 2] //read current value of v[i]
        ldr w21, [x29, temp_s] //read temp value from the stack
        mov w21, w27 //temp= v[i]
        str w21, [x29, temp_s] //store new value of temp variable


//      ldr w20, [x29, j_s] //read j value from the stack
//      ldr w19, [x29, i_s] //read i value from the stack
//      ldr w19, [x24, i_s] //read i value
        mov w20, w19 // j =i
        str w20, [x29, i_s] //store current value of j
        cmp w20, 0
        b.le j_array //if j<=0 then branch to  v[j] = temp
        b test_4 //if j>0, branch to check next condition


test_1:
        cmp w19, size
        b.lt loop_1 //is i < size? if yes, begin loop_1
        mov w19, 1 //if i >= size, re-initialize i to 1 for the second for loop
        str w19, [x29, i_s] //store the current value of i
        b test_2 //branch to test_2

test_2: cmp w19, size
        b.ge print_1 //if i>= size? if yes, skip to print_1
        b loop_2 //if i<size, enter the second for loop


test_3:
        cmp w20, 0 //compare value of j to 0
        b.gt test_4 //if j>0, branch to test the second condition of the loop
        add x24, x29, array_s
        ldr w20, [x24, w20, sxtw 2] //get value of v[j]
        ldr w21, [x29, temp_s] //get value of tmep
        str w21, [x24, w20, sxtw 2] //v[j] = temp
        add w19, w19, 1 //if j<=0, i++
        str w19, [x29, i_s] //store current value of i
        b test_2 //branch back to test the second loop

test_4:
        add x24, x29, array_s

        ldr w25, [x29, temp2_s] //reading value of temp2_r variable from the stack
        ldr w20, [x29, j_s] //get current j value
        sub w25, w20, 1 //temp2 = j-1
//      str w25, [x29, temp2_s] //store current temp 2 value
//      ldr w21, [x29, temp_s] //reading value of temp variable of stack
        ldr w26, [x24, w25, sxtw 2] // reading value v[j-1] and assigning it to a temporary register
//      str w26, [x29, temp3_s]
//      ldr w21, [x29, temp_s] //get value of temp
        cmp w21, w26 //compare temp and v[j-1] values
        b.lt loop_3 //if temp < v[j-1], enter the nested loop
loop_3:
//      ldr w20, [x24, w20, sxtw 2]//reading value of v[j]
//      ldr w25, [x29, temp_s]
        add x24, x29, array_s
        ldr w20, [x29, j_s] //get value of j
//      ldr w25, [x29, temp2_s] // get value of temp2
        ldr w28, [x29, temp3_s]
        sub w28, w20, 1 // temp3 = j-1

//      str w25, [x28, temp2_s] //store new value of temp2
        ldr w26, [x24, w25, sxtw 2] //other temp = v[j-1]
        str w26, [x24, w20, sxtw 2] //v[j] = v[j-1]
        sub w20, w20, 1 //j--
        str w20, [x29, j_s] //store current value of j
        cmp w20, 0 //compare j to 0
        b.le j_array //if j>0 check second condition
        b test_4 //branch back to test first condition of the nested loop

//      sub w20, w20, 1 //j--

        //v[j] = v[j-1]
        //v[j] = temp
        //branch to last part
j_array:
//      ldr w21, [x29, temp_s] //reading value of temp _r
        str w21, [x24, w20, sxtw 2] // v[j] = temp
        add w19, w19, 1 //i++
        b test_2 //check condition of outer loop

print_1:
        adrp x0, print_sorted
        add w0, w0, :lo12:print_sorted
        mov w1, 0
        bl printf

        mov w19, 0 //reset i value to 0
        str w19, [x29, i_s] //store current of i
        cmp w19, size
test_5: cmp w19, size
        b.lt loop_4 //if i<size, branch to print loop
        b end //if i>= size, branch to end



loop_4:
        adrp x0, fmt
        add w0, w0, :lo12:fmt
        mov w1, w19
//      add x23, x29, array_s
        ldr w27, [x24, w19, sxtw 2]
        mov w2, w27
        bl printf //branch and link instruction to print

        add w19, w19, 1 //increment i by 1
        str w19, [x29, i_s] //store current value of i
        b test_5 //branch back to test_5
end:
        mov w0, 0
        ldp x29, x30, [sp], dealloc
        ret
