/**
Mila Hoogstraat
ID: 30055558
Assignment 5 Part b)
Lecture 01
***/

 //number of arguments represented with w19 register 
 //array of pointers to the arguments represented with x20 register 

	.text //text section 
//strings for each month 	 
jan: .string "January"
feb: .string "February"
mar: .string "March"
apr: .string "April"
may: .string "May"
jun: .string "June"
jul: .string "July"
aug: .string "August"
sep: .string "September"
oct: .string "October"
nov: .string "November"
dec: .string "December" 
win_m: .string "Winter"
spr_m: .string "Spring"
sum_m: .string "Summer"
fal_m: .string "Fall"
//strings for each suffix 
suff_1: .string "st"
suff_2: .string "nd"
suff_3: .string "rd"
suff_4: .string "th"

usage:.string "usage: a5b mm dd\n" //prints when number of arguments is not 3 
date_err: .string "This date does not exist.\n" //prints when provided date does not exist 

fmt: .string "%s %d%s is %s\n" //prints the season according to date provided 

	.data //data section 
        .balign 8 //pads the location counter to ensure the instructions are aligned properly 

season_m: .dword win_m, spr_m, sum_m, fal_m //array of seasons 
month_m: .dword jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec //array of months 
suff_m: .dword suff_1, suff_2, suff_3, suff_4 //array of suffixes 


	.text //.text section 
	.balign 4 //pads the location counter to ensure the instructions are aligned properly 
	.global main  //makes main function visible to the OS 



main: 
	stp x29, x30, [sp, -16]! //store frame pointer and local register to the stack 
	mov x29,sp //updates the FP register to the current SP register 

	mov w19, w0 //number of arguments moved onto register w0
	mov x20, x1 //array of pointers to the arguments moved onto register x1
	
	cmp w19, 3 //check if number of arguments is 3
	b.eq check_month //if so, branch to check_month

	bl usage_error //if not, branch to usage_error 

check_month: 
	mov w19, 1 //move int 1 into w19 register 
	ldr x0, [x20, w19, SXTW 3] //load second argument onto w0 register

	bl atoi //convert ASCII string to integer and load result onto w0 register
	mov w24, w0 //move integer result onto w24 register 
	cmp w24, 1 //check if month number is greater or equal to 1 
	b.lt day_error //if month number is less than 1, branch to invalid_error
	cmp w24, 12 //check if month number is greater than 12
	b.gt day_error //if so, branch to invalid_error

	


check_day:
	mov w23, 2 //move int 2 onto w23 register 
        sdiv w22, w24, w23 //load month/2 onto w22 register
        msub w21, w22, w23, w24 //load month - (month/2 x 2) onto register w21 (this is the remainder of the month/2)

        cmp w21, 1 //compare remainder of month/2 with 1
	
        b.eq check_31 //if remainder is 1, then most of these months have 31 days (months 1,3,5, and 7 are now out of the way. now we do a second check for the exceptions)
        bl check_30 //if remainder is not 1, branch to check_30

 
	
feb_test:
	mov w19, 2 //check if month is February 
	ldr x0, [x20, w19, SXTW 3] //get day 
	bl atoi //convert ASCII string to int and store on w0 register 
	mov w25, w0 //move int result onto w25 register 
	cmp w25, 28 //check if date is Feb 28 
	b.gt day_error //if date is later than feb 28, branch to day_error
	bl get_suffix //if not, branch to get_suffix 

check_31: //checks if date exists in months with 31 days, and checks the exception months 
	cmp w24, 9 //if the month is september 
        b.eq check_30 //check that the date exists (nothing over 30)
        cmp w24, 7 //if the month is july
        b.eq check_30 //check that the date exists (nothing over 30)
        cmp w24, 11 //if the month is november
        b.eq check_30 //check that the date exists (nothing over 30)
        cmp w24, 4 //if the month is april
        b.eq check_30 //check that the date exists (nothing over 30)

	mov w19, 2 //move int 2 onto w19 register 
	ldr x0, [x20, w19, SXTW 3] //load third argument onto x0 register
	bl atoi //convert ASCII string to integer and load result onto w0 register
	mov w25, w0 //move int result onto w25 register 
	cmp w0, 31 //compare day argument with 31 
	b.gt day_error //if day is greater than 31, branch to invalid_error
	cmp w0, 1 //compare day argument with 1 
	b.lt day_error //if day is less than 1, branch to invalid_error 

	bl get_suffix//if date passes these tests, branch to get_suffix 
 
check_30:
	cmp w24, 1 //if the months is january
	b.eq check_31  //check that it has no more than 31 days
	cmp w24, 8 //if the month is august
	b.eq check_31 //check that it has no more than 31 days 

 	cmp w24, 10 //if the month is october
	b.eq check_31 //check that it has no more than 31 days 

	cmp w24, 12 //if the month is december
	b.eq check_31  //check that it has no more than 31 days 

	cmp w24, 2 //check if month is february
	b.eq feb_test //if so, branch to feb_test 
	
	mov w19, 2 //if not change index of arguments array to 2 
	ldr x0, [x20, w19, SXTW 3] //load x0 with the second argument (day)
	bl atoi //convert ASCII string to int and store result on w0 register 
	mov w25, w0 //move result onto w25 register 
	cmp w25, 30 //check that date is not later than the 30th 
	b.gt day_error  //if it is greater, branch to day_error

	bl get_suffix //if date passes the tests, branch to get_suffix 

get_suffix:
	mov w19, 2 //move int 2 onto register w19 
	ldr x0, [x20, w19, SXTW 3] //load x0 with the second argument (day)
	bl atoi //convert ASCII string to int and store result on w0 register 
	mov w25, w0 //move result onto w25 register 

	cmp w25, 1 //check if day == 1
	b.eq set_st //if so, branch to set_st
 
	cmp w25, 21 //check if day == 21
	b.eq set_st //if so, branch to set_st

	cmp w25, 31 //check if day == 31
	b.eq set_st //if so, branch to set_st

	cmp w25, 2 //check if day == 2
	b.eq set_nd //if so, branch to set_nd

	cmp w25, 22 //check if day == 22
	b.eq set_nd //if so, branch to set_nd
	
	cmp w25, 3 //check if day == 3
	b.eq set_rd //if so, branch to set_rd

	cmp w25, 23 //check if day == 23
	b.eq set_rd //if so branch to set_rd

	bl set_th //if day is none of the above, it must have the "th" suffix. branch to set_th 

get_season:
	cmp w24, 2 //check if month is february or before (i.e january)
	b.le winter //if so, then the season is winter. branch to winter
	
	cmp w24, 3 //check if month is march 
	b.eq march_check //if so, then branch to march_check

	cmp w24, 5 //check if month is may or before (april)
	b.le spring //if so, then branch to spring 

	cmp w24, 6 //check if month is june 
	b.eq june_check //if so, then branch to june_check
 
	cmp w24, 8 //check if month is august or before (july)
	b.le summer //if so, then branch to summer 

	cmp w24, 9 //check if month is september
	b.eq sept_check //if so then branch to sept_check
	
	cmp w24, 11 //check if month is november or before (october)
	b.le fall //if so, branch to fall 

	cmp w24, 12 //check if month is december
	b.eq dec_check //if so, branch to dec_check 

march_check: //checks if date in march is winter or spring 
	cmp w25, 20 //compare the day with the 20th 
	b.le winter //if day is before the 20th, it is winter. branch to winter
	bl spring //if day is the 21st or later, then it is spring. branch to spring 

june_check: //checks if date in june is spring or summer 
	cmp w25, 20 //compare the day with the 20th 
	b.le spring //if the day is before the 20th, it is spring. branch to spring
	bl summer //if the day is the 21st or later, then it is summer. branch to summer 
sept_check: //checks if date in september is summer or fall
	cmp w25, 20 //compare the day with the 20th 
	b.le summer //if the day is before the 20th, it is summer. branch to summer
	bl fall //if the day is the 21st or later, then it is fall. branch to fall
dec_check: //checks if the date in december is fall or winter 
	cmp w25, 20 //compare the day with the 20th 
	b.le fall //if the day is before the 20th, it is fall. branch to fall 
	bl winter //if the day is the 21st or later, then it is winter. branch to winter	


//setting season 
winter: //sets season to winter 
	mov w26, 0 //move int 0 into register w26 (index of season array)
	bl print //branch to print 

spring: //sets season to spring 
	mov w26, 1 //move int 1 into register w26 (index of season array)
	bl print //branch to print 

summer: //sets season to summer 
	mov w26, 2 //move int 2 into register w26 (index of season array)
	bl print //branch to print
 
fall: //sets season to fall
	mov w26, 3 //move int 3 into register w26 (index of season array)
	bl print //branch to print 

//setting suffixes 
set_st: //sets suffix to 'st'
	mov w27, 0 //set index for suffix array to 0
	bl get_season //branch to get_season 

set_nd: //sets suffix to 'nd'
	mov w27, 1 //set index for suffix array to 1
	bl get_season //branch to get_season 

set_rd: //sets suffix to 'rd'
	mov w27, 2 //set index for suffix array to 2 
	bl get_season //branch to get_season 

set_th: //sets suffix to 'th'
	mov w27, 3 //set index for suffix array to 3 
	bl get_season //branch to get_season 

usage_error: //occurs when invalid number of arguments is provided 
	adrp x0, usage //reserve x0 register as first argument for printf
	add x0, x0, :lo12:usage //adding low 12 bits to x0 register 
	bl printf //branch and link instruction to printf
	bl end //branch to end 

day_error: //occurs when date that doesnt exist is provided as argument
	adrp x0, date_err //reserve x0 register as first argument for printf
	add x0, x0, :lo12:date_err //adding low 12 bits to x0 register 
	bl printf //branch and link instruction to print f
	bl end //branch to end 

print: //prints season based on date provided 
	adrp x0, fmt //reserve x0 register as first argument for printf
	add x0, x0, :lo12:fmt //adding low 12 bits to x0 register

	adrp x22, month_m //get current address of month array 
	add x22, x22, :lo12:month_m //add low 12 bits to x22 register 
	sub w24, w24, 1 //substract 1 from month int because arrays start at 0 
	ldr x1, [x22, w24, SXTW 3] //load month value onto x1 register as argument for printf 

	mov w2, w25 //move day value onto w2 register as argument for printf 

	adrp x23, suff_m //get current address of suffix array 
	add x23, x23, :lo12:suff_m //add low 12 bits to x23 register 
	ldr x3, [x23, w27, SXTW 3] //load suffix value onto x3 register as argument for printf 

	adrp x24, season_m //get current address of season array 
	add x24, x24, :lo12:season_m //add low 12 bits to the x24 register 
	ldr x4, [x24, w26, SXTW 3] //load season value onto x4 register as argument for printf 

	bl printf //branch and link instruction to printf
end:
	ldp x29, x30, [sp], 16 //restores state
	ret //return to caller 
