/**
Assignment 1b
Name: Mila Hoogstraat
UCID: 30055558
CPSC 355
Lecture 02
******/

//polynomial coefficients (macro definitions)
//defining x22 as coefficient a
//definining x23 as coefficient b
//defining x24 as coefficient c
//defining x25 as coefficient d


fmt: .string "When x = %d, y = %d, and the current maximum is: %d\n" //creates the format string
        .balign 4 //pads the location counter to ensure the instructions are aligned properly
        .global main//makes the "main" function visible to the OS


main:
        stp x29, x30, [sp,-16]! //saves the state
        mov x29, sp //updates the FP register to the current SP register

        //instructs the x19 macro to expand to the x19 register
         //instructs the x20 macro to expand to the x20 register
        //instructs the x21 macro to expand to the x21 register

        mov x21,-9999 //setting the intial value of the current maximum for the start of the loop
        mov x20, -6 //setting the intiial value of x for the start of the loop
              
loop: 
	mov x19,0  //resets the value of y to integer 0 at start of the loop
        mov x22, -5 //setting coefficient a to integer -5
        mov x23,-31 //setting coefficient b to integer -31
        mov x24, 4 //setting coefficient c to integer 4
        mov x25, 31 //setting coefficient d to integer 31

        mul x22, x22, x20 //-5x
        mul x22, x22, x20 //-5x^2
        madd x19, x22, x20, x19 //y = -5x^2*x




        mul x23, x23, x20 //-31x
        madd x19, x23, x20, x19 // y = -5x^3 + -31x^2

        madd x19, x24,x20, x19 // -5x^3 + -31x^2 +4x

        add x19,x19,x25 // y = -5x^3 + -31x^2 + 4x +31

        cmp x19, x21 //check if y > current maximum
        b.gt setNewMax //if true, branch to setNewMax

        b test //branch to test (pre-test loop)

test: //pre-test loop
        cmp x20, 5 //check if current x is in the range 
        b.gt end //if x>5, exit the loop and branch to end 





print:
        adrp x0, fmt //reserves x0 register as first argument for printf
        add x0, x0, :lo12:fmt //adding low 12 bits to the x0 register
        mov x1, x20 //moving current value of x into the x1 register
        mov x2, x19 //moving current value of y into the x2 register
        mov x3, x21 //moving value of current maximum into the x3 register
        bl printf //call printf
        add x20,x20,1 //increase the value of x by 1 to iterate through the loop
        b loop //start the loop again


setNewMax: //updates the current maximum
        mov x21, x19 //setting new maximum as the last y obtained from the loop
        b print //branch to print

end:
        ldp x29, x30, [sp], 16 //restores state
        ret //return to the caller
                                                                                                                                                                      

