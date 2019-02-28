//Global Variables
QUEUESIZE = 8
MODMASK = 0x7
FALSE = 0
TRUE = 1


.data
	head: .word -1
	tail: .word -1

.bss
	queue: .skip QUEUESIZE * 4 //queuesize * 4 because each element has 4 bytes

.text
	



//strings
queue_over: .string "\nQueue overflow! Cannot enqueue into a full queue.\n" 
queue_under: .string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
queue_empty: .string "\nEmpty queue\n"
queue_current: .string "\nCurrent queue contents:\n"
queue_head: .string "<-- head of queue"
queue_tail: .string "<-- tail of queue"
queue_i: .string "%d" 
new:.string "\n"
.balign 4


.global enqueue

enqueue:
	stp x29, x30, [sp, -16]!
	mov x29, sp 

	mov w9, w0 
	bl queueFull
	cmp w22, TRUE
	b.ne check_empty
	
	adrp x0, queue_over
	add x0, x0, :lo12:queue_over
	bl printf 

	bl end_enqueue

check_empty:
	bl queueEmpty
	cmp w22, TRUE
	b.ne else 

	mov w21, 0 //head = 0 
	str w21, [x19]
	mov w20, 0  //tail = 0 
	str w20, [x20]
	b exit_if

else: 
	add w20, w20, 1 //tail ++ 
	and w20, w20, MODMASK 

exit_if: 
	adrp x19, queue 
	add x19, x19, :lo12:queue
	str w9, [x19, w20, SXTW 2] //queue[tail] = value 


end_enqueue: 
	ldp x29, x30, [sp], 16
	ret 



.global dequeue

dequeue:
	stp x29, x30, [sp, -16]!
	mov x29, sp 
	
	bl queueEmpty
	cmp w22, TRUE 
	b.ne next_d
	adrp x0, queue_under
	add x0, x0, :lo12:queue_under
	bl printf 
	mov w0, -1 
	bl end_dequeue

next_d:
	adrp x19, queue
	add x19, x19, :lo12:queue
	
	ldr w10, [x19, w21, SXTW 2] //value = queue[head]
	cmp w21, w20 //compare head with tail 

	b.ne else_d
	mov w21, -1 //head = -1
	str w21, [x19]
	mov w20, -1 //tail = -1 
	str w20, [x20]
	bl next2_d 


else_d:
	add w21, w21, 1 //head ++ 
	and w21, w21, MODMASK 
	str w21, [x19]

next2_d: 
	mov w0, w10

end_dequeue:
	ldp x29, x30, [sp], 16
	ret 
	
	
.global queueFull

queueFull: 
	stp x29, x30, [sp, -16]!
	mov x29, sp

	//accessing tail
	adrp x20, tail
	add x20, x20, :lo12:tail
	ldr w20, [x20]
	//accessing head: -1	
	adrp x19, head
	add x19, x19, :lo12:head
	ldr w21, [x19] 

	add w9, w20, 1 //tail + 1 
	and w10, w9, MODMASK //(tail + 1) & MODMASK
	cmp w10, w20 //does (tail + 1) & MODMASK == head?
	b.ne false_1 //if not branch to false 
	
	mov w22, TRUE 
	
	bl end_full

false_1:
	mov w22, FALSE
	
end_full:
	ldp x29, x30, [sp], 16
	ret 
.global queueEmpty
queueEmpty:
	stp x29, x30, [sp, -16]!
	mov x29, sp
	
	adrp x19, head
	add x19, x19, :lo12:head
	ldr w21, [x19]

	cmp w21, -1 //if head == -1
	b.ne false_2
	mov w22, TRUE 
	
	bl end_empty
false_2:
	mov w22, FALSE

end_empty:
	ldp x29, x30, [sp], 16
	ret 
.global display
display:
	stp x29, x30, [sp, -16]!
	mov x29, sp
 
	bl queueEmpty
	cmp w22, TRUE
	b.ne display_next
	//if queue is empty, print
	adrp x0, queue_empty 
	add x0, x0, :lo12:queue_empty
	bl printf 

	bl end



display_next: 
	adrp x19, head
	add x19, x19, :lo12:head
	ldr w21 ,[x19]

	adrp x20, tail
	add x20, x20, :lo12:tail
	ldr w20, [x20]

	sub w23, w20, w21 //count = tail - head
	add w23, w23, 1 //count = tail - head + 1
	
	cmp w23, 0 //is count <= 0?
	b.gt next_2  //if not branch to next_2
	add w23, w23, QUEUESIZE //if yes, count += QUEUESIZE 

next_2: 
	adrp x0, queue_current
	add x0, x0, :lo12:queue_current
	bl printf

	adrp x19, head
	add x19, x19, :lo12:head
	ldr w21, [x19]
	
	mov w24, w21 //i = head 

	mov w25, 0 //j = 0


	bl test



loop: 
	adrp x19, queue 
	add x19, x19, :lo12:queue
	ldr w26, [x19, w24, SXTW 2] //queue[i] value loaded onto register w25

	adrp x0, queue_i
	add x0, x0, :lo12:queue_i
	mov w1, w26 //%d = queue[i] value 
	bl printf 

	adrp x19, head
	add x19, x19, :lo12:head
	ldr w21, [x19]

	cmp w24, w21 //compare i and head
	b.ne next_if
	
	adrp x0, queue_head //if i == head
	add x0, x0, :lo12:queue_head
	bl printf 	
next_if:
	adrp x20, tail
	add x20, x20, :lo12:tail
	ldr w20, [x20]
	
	cmp w24, w20 //compare i and tail
	b.ne exit_ifs
	
	adrp x0, queue_tail //if i == tail
	add x0, x0, :lo12:queue_tail
	bl printf

exit_ifs: 
	adrp x0, new
	add x0, x0, :lo12:new
	bl printf

	add w24, w24, 1 //i++
	and w24, w24, MODMASK 

	add w25, w25, 1 //j++
test: 
	cmp w25, w23 //check if j < count
	b.lt loop //if j is bigger or equal to count, branch to end 


end:
	ldp x29, x30, [sp], 16
	ret 
