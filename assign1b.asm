/**
Assignment 1b
Name: Mila Hoogstraat
UCID: 30055558
CPSC 355
Lecture 02
******/

//polynomial coefficients (macro definitions)
define(a_r, x22)//defining a_r as coefficient a
define(b_r, x23)//definining b_r as coefficient b
define(c_r, x24)//defining c_r as coefficient c
define(d_r, x25)//defining d_r as coefficient d


fmt: .string "When x = %d, y = %d, and the current maximum is: %d\n" //creates the format string
        .balign 4 //pads the location counter to ensure the instructions are aligned properly
        .global main//makes the "main" function visible to the OS


main:
        stp x29, x30, [sp,-16]! //saves the state
        mov x29, sp //updates the FP register to the current SP register

        define(y_r, x19)//instructs the y_r macro to expand to the x19 register
        define(x_r,x20) //instructs the x_r macro to expand to the x20 register
        define(max_r,x21)//instructs the max_r macro to expand to the x21 register

        mov max_r,-9999 //setting the intial value of the current maximum for the start of the loop
        mov x_r, -6 //setting the intiial value of x for the start of the loop
              
loop: 
	mov y_r,0  //resets the value of y to integer 0 at start of the loop
        mov a_r, -5 //setting coefficient a to integer -5
        mov b_r,-31 //setting coefficient b to integer -31
        mov c_r, 4 //setting coefficient c to integer 4
        mov d_r, 31 //setting coefficient d to integer 31

        mul a_r, a_r, x_r //-5x
        mul a_r, a_r, x_r //-5x^2
        madd y_r, a_r, x_r, y_r //y = -5x^2*x




        mul b_r, b_r, x_r //-31x
        madd y_r, b_r, x_r, y_r // y = -5x^3 + -31x^2

        madd y_r, c_r,x_r, y_r // -5x^3 + -31x^2 +4x

        add y_r,y_r,d_r // y = -5x^3 + -31x^2 + 4x +31

        cmp y_r, max_r //check if y > current maximum
        b.gt setNewMax //if true, branch to setNewMax

        b test //branch to test (pre-test loop)

test: //pre-test loop
        cmp x_r, 5 //check if current x is in the range 
        b.gt end //if x>5, exit the loop and branch to end 





print:
        adrp x0, fmt //reserves x0 register as first argument for printf
        add x0, x0, :lo12:fmt //adding low 12 bits to the x0 register
        mov x1, x_r //moving current value of x into the x1 register
        mov x2, y_r //moving current value of y into the x2 register
        mov x3, max_r //moving value of current maximum into the x3 register
        bl printf //call printf
        add x_r,x_r,1 //increase the value of x by 1 to iterate through the loop
        b loop //start the loop again


setNewMax: //updates the current maximum
        mov max_r, y_r //setting new maximum as the last y obtained from the loop
        b print //branch to print

end:
        ldp x29, x30, [sp], 16 //restores state
        ret //return to the caller
                                                                                                                                                                      

