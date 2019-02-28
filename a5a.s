/**
Mila Hoogstraat
ID: 30055558
Assignment 5 Part a)
Lecture 01
**/

//Global Variables
QUEUESIZE = 8 //size of queue is 8 
MODMASK = 0x7 //MODMASK value from C code 
FALSE = 0 //false truth value is represented by int 0 
TRUE = 1 //true truth value is represented by int 1 


.data //.data section 
        head: .word -1 //head = - 1 
        tail: .word -1 //tail = -1 

.bss //.bss section
        queue: .skip QUEUESIZE * 4 //int array 

.text //.text section 




//strings to print 
queue_over: .string "\nQueue overflow! Cannot enqueue into a full queue.\n" //prints when an attempt to enqueue onto a full queue is made 
queue_under: .string "\nQueue underflow! Cannot dequeue from an empty queue.\n" //prints when an attemp to dequeue from an empty queue is made 
queue_empty: .string "\nEmpty queue\n" //prints when attempt to display empty queue is made 
queue_current: .string "\nCurrent queue contents:\n" //prints when displaying a non empty queue 
queue_head: .string "<-- head of queue" //displays head of non empty queue 
queue_tail: .string "<-- tail of queue" //displays tail of non empty queue 
queue_i: .string "%d" //used when displaying queue[i]
new:.string "\n" //used when making new line in printing 

.balign 4 //pads the location counter to ensure the instructions are aligned properly 


.global enqueue //making enqueue function visible to the OS 

enqueue:
        stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack 
        mov x29, sp //updates the FP register to the current SP register 

        mov w14, w0 //move value being passed into enqueue into the w14 register
        bl queueFull //branch to queueFull
        cmp w22, TRUE //check if queue is full
        b.ne check_empty //if it is not, check that it is empty by branching to check_empty

        adrp x0, queue_over //reserves x0 register as first argument for printf
        add x0, x0, :lo12:queue_over //adding low 12 bits to the x0 register
        bl printf //branch & link instruction to prinf
 
        bl end_enqueue //branch to end_enqueue

check_empty: //checks if queue is currently empty 
        bl queueEmpty //branch to queueEmpty
        cmp w22, TRUE //check if queue is empty 
        b.ne else //if not empty, branch to else 

	adrp x9, head //if queue is empty, get current address of head 
	add x9, x9, :lo12:head //add low 12 bits to the x9 register 

        mov w21, 0 //head = 0
        str w21, [x9] //store new head value onto w21 register 

	adrp x10, tail //get current tail address
        add x10, x10, :lo12:tail //add low 12 bits onto x10 register

    	mov w20, 0  //tail = 0
        str w20, [x10] //store new tail value onto w20 register 

        b exit_if //branch to exit_if

else:
	adrp x10, tail //get current address of tail 
	add x10, x10, :lo12:tail //add low 12 bits onto x10 register 
	ldr w20, [x10] //load current tail value onto w20 register

        add w20, w20, 1 //tail ++
        and w20, w20, MODMASK //tail = tail ++ & MODMASK 
	str w20, [x10] //store current value of tail onto w20 register 

exit_if:
	adrp x10, tail //get current address of tail 
	add x10, x10, :lo12:tail //adding low 12 bits to x10 register
	ldr w20, [x10] //load current value of tail onto w20 register 

        adrp x12, queue //get current address of the queue 
        add x12, x12, :lo12:queue //adding low 12 bits onto x12 register
        str w14, [x12, w20, SXTW 2] //queue[tail] = value


end_enqueue: 
	 ldp x29, x30, [sp], 16 //restores state
         ret //returns to caller 



.global dequeue //making dequeue function visible to the OS 

dequeue:
        stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack 
        mov x29, sp //updates the FP register to the current SP register 

        bl queueEmpty //branch to queueEmpty
        cmp w22, TRUE //check if queue is empty
        b.ne next_d //if queue is not empty, branch to next_d

        adrp x0, queue_under //if queue is empty, reserve x0 register as first argument for printf
        add x0, x0, :lo12:queue_under //adding low 12 bits onto x0 register
        bl printf //branch & link instruction to printf

        mov w0, -1 //value to be returned 
        bl end_dequeue //branch to end_dequeue 

next_d:
        adrp x12, queue //get current address of the queue 
        add x12, x12, :lo12:queue //add low 12 bits onto x12 register 

	adrp x9, head //get current address of head 
	add x9, x9, :lo12:head //add low 12 bits onto x9 register 
 
	adrp x10, tail //get current address of tail
	add x10, x10, :lo12:tail //add low 12 bits onto x10 register
	ldr w20, [x10] //load current value of tail onto w20 register
	
	ldr w21, [x9] //load current value of head onto w21 register 
        ldr w10, [x12, w21, SXTW 2] //value = queue[head]
        cmp w21, w20 //compare head with tail

        b.ne else_d //if head does not equal tail, branch to else_d
        mov w21, -1 //head = -1
        str w21, [x9] //store current head value onto w21 register 
        mov w20, -1 //tail = -1        
        bl next2_d //branch to next2_d


else_d:
        add w21, w21, 1 //head ++
        and w21, w21, MODMASK //head = ++head & MODMASK 
        str w21, [x9] //store current head value onto w21 register 

next2_d:
        mov w0, w10 //value to be returned 

end_dequeue:
        ldp x29, x30, [sp], 16 //restores state
        ret //return to caller 
 

.global queueFull //making queueFull function visible to the OS 

queueFull:
        stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack
        mov x29, sp //updates the FP register to the current SP register

        
        adrp x10, tail //get current address of tail 
        add x10, x10, :lo12:tail //adding low 12 bits to the x10 register
        ldr w20, [x10] //load current value of tail onto w20 register 
        
        adrp x9, head//get current address of head 
        add x9, x9, :lo12:head //adding low 12 bits to the x9 register
        ldr w21, [x9] //load current value of head onto w21 register

        add w9, w20, 1 //tail + 1
        and w10, w9, MODMASK //(tail + 1) & MODMASK
        cmp w10, w21 //does (tail + 1) & MODMASK == head?
        b.ne false_1 //if not branch to false

        mov w22, TRUE //if yes set truth value to true 
	bl end_full //branch to end_full

false_1:
        mov w22, FALSE //set truth value to false 

end_full:
        ldp x29, x30, [sp], 16 //restores state 
        ret //return to caller 

.global queueEmpty //making queueEmpty function visible to the OS 
queueEmpty:
        stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack
        mov x29, sp //updates the FP register to the current SP register
 
        adrp x9, head //get current address of head 
        add x9, x9, :lo12:head //add low 12 btis to the x9 register
        ldr w21, [x9] //load current value of head onto w21 register 

        cmp w21, -1 //compare head and int -1 
        b.ne false_2  //if head is not -1, then queue is not empty 
        mov w22, TRUE //if head == -1, then queue is empty

        bl end_empty //branch to end_empty 

false_2:
        mov w22, FALSE //set truth value to false 

end_empty:
        ldp x29, x30, [sp], 16 //restore state
        ret //return to caller 

.global display //make display function visible to the OS 
display:
        stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack
        mov x29, sp //updates the FP register to the current SP register

        bl queueEmpty //branch to queueEmpty
        cmp w22, TRUE //check if queue is empty
        b.ne display_next //if queue is not empty, branch to display_next

        //if queue is empty, print
        adrp x0, queue_empty //reserve x0 register as first argument for printf
        add x0, x0, :lo12:queue_empty //adding low 12 bits to the x0 register
        bl printf //branch and link instruction to printf

        bl end //since queue is empty, branch to end of program 



display_next:
        adrp x9, head //get current address of head 
        add x9, x9, :lo12:head //adding low 12 bits to the x9 register
        ldr w21 ,[x9] //load current value of head onto w21 register 

        adrp x10, tail //get current address of tail 
        add x10, x10, :lo12:tail //adding low 12 bits to the x10 register
        ldr w20, [x10] //load current value of tail onto w20 register

        sub w23, w20, w21 //count = tail - head
        add w23, w23, 1 //count = tail - head + 1

        cmp w23, 0 //is count <= 0?
        b.gt next_2  //if not branch to next_2
        add w23, w23, QUEUESIZE //if yes, count += QUEUESIZE

next_2:
        adrp x0, queue_current //reserve x0 register as first argument for printf
        add x0, x0, :lo12:queue_current //adding low12 bits to the x0 register
	bl printf //branch and link instruction to printf

        adrp x9, head //get current address of head 
        add x9, x9, :lo12:head //adding low 12 bits to the x9 register
        ldr w21, [x9] //load head value onto w21 register

        mov w24, w21 //i = head

        mov w25, 0 //j = 0


        bl test //branch to pretest loop 



loop:
        adrp x12, queue //get current address of the queue
        add x12, x12, :lo12:queue //adding low 12 bits to the x12 register
        ldr w26, [x12, w24, SXTW 2] //queue[i] value loaded onto register w26

        adrp x0, queue_i //reserve x0 register as first argument for printf
        add x0, x0, :lo12:queue_i //adding low 12 bits to the x0 register
        mov w1, w26 //%d = queue[i] value
        bl printf //branch & link instruction to printf

        adrp x9, head //get current address of head
        add x9, x9, :lo12:head // adding low 12 bits to the x9 register 
        ldr w21, [x9] //load value of head onto w21 register

        cmp w24, w21 //compare i and head
        b.ne next_if //if i and head not equal branch to next_if

        adrp x0, queue_head //if i == head reserve x0 register for first argument of printf
        add x0, x0, :lo12:queue_head //adding low 12 bits to the x0 register 
        bl printf //branch & link instruction to printf
next_if:
        adrp x10, tail //get the current addresss of tail 
        add x10, x10, :lo12:tail //adding low12 bits to the x10 register
        ldr w20, [x10] //load tail value onto w20 register

        cmp w24, w20 //compare i and tail
        b.ne exit_ifs //if i does not equal tail branch to exit_ifs

        adrp x0, queue_tail //if i == tail, reserve x0 register as first argument for printf
        add x0, x0, :lo12:queue_tail //adding low 12 bits to the x0 register
        bl printf //branch & link instruction to printf

exit_ifs:
        adrp x0, new //reserves the x0 register as first argument for printf
        add x0, x0, :lo12:new //adding low 12 bits to the x0 register
        bl printf //branch & link instruction to printf

        add w24, w24, 1 //i++
        and w24, w24, MODMASK //i == ++i & MODMASK 

        add w25, w25, 1 //j++
test:
        cmp w25, w23 //check if j < count
        b.lt loop //if so, begin the loop 


end:
        ldp x29, x30, [sp], 16 //restores state 
        ret //return to caller 



