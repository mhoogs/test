		// Equates for struct1
		i1_s = 0
		j1_s = 4
		struct1_size = 8

		// Equates for struct2
		i2_s = 0
		j2_s = 8
		struct2_size = 16

		// Equates for nested struct
		i3_s = 0
		struct1_s = 4
		struct2_s = 12
		nested_struct_size = 28

		// function: init
		alloc = -(16 + nested_struct_size) & -16
		dealloc = -alloc
		n_s = 16
init: 	stp	x29, x30, [sp, alloc]!
		mov x29, sp
		// initialize the nested struct
		str wzr, [x29, n_s + i3_s]
		str wzr, [x29, n_s + struct1_s + i1_s]
		str wzr, [x29, n_s + struct1_s + j1_s]
		str xzr, [x29, n_s + struct2_s + i2_s]
		str xzr, [x29, n_s + struct2_s + j2_s]
		
		// return initialized value by copying it into memory at address in x8
		// return i_3
		ldr w9, [x29, n_s + i3_s]
		str w9, [x8, i3_s]
		// return struct_1
		ldr w9, [x29, n_s + struct1_s + i1_s]
		str w9, [x8, struct1_s + i1_s]
		ldr w9, [x29, n_s + struct1_s + j1_s]
		str w9, [x8, struct1_s + j1_s]
		// return struct2
		ldr x9, [x29, n_s + struct2_s + i2_s]
		str x9, [x8, struct2_s + i2_s]
		ldr x9, [x29, n_s + struct2_s + j2_s]
		str x9, [x8, struct2_s + j2_s]
		// return 
		ldp  x29, x30, [sp], dealloc
		ret

fmtprint:	.string	"i_3 = %d, i_1 = %d, j_1 = %d, i_2 = %d, j_2 = %d\n "
			.balign 4
printstruct:
			stp		x29, x30, [sp, -16]!
			mov		x29, sp
			//call printf
			ldr		w1, [x0, i3_s]
			ldr		w2, [x0, struct1_s + i1_s]
			ldr		w3, [x0, struct1_s + j1_s]
			ldr		x4, [x0, struct2_s + i2_s]
			ldr		x5, [x0, struct2_s + j2_s]
			adrp	x0, fmtprint
			add		x0, x0, :lo12:fmtprint
			bl printf
			//return
			ldp		x29, x30, [sp], 16
			ret

modifystruct:
			stp		x29, x30, [sp, -16]!
			mov		x29, sp
			//modify i_3
			ldr		w9, [x0, i3_s]
			mov		w9, w1
			str 	w9, [x0, i3_s]
			//struct1
			ldr		w9, [x0, struct1_s + i1_s]
			mov		w9, w2
			str 	w9, [x0, struct1_s + i1_s]
			ldr		w9, [x0, struct1_s + j1_s]
			mov		w9, w3
			str 	w9, [x0, struct1_s + j1_s]
			//struct2
			ldr		x9, [x0, struct2_s + i2_s]
			mov		x9, x4
			str 	x9, [x0, struct2_s + i2_s]
			ldr		x9, [x0, struct2_s + j2_s]
			mov		x9, x5
			str 	x9, [x0, struct2_s + j2_s]
			//return
			ldp		x29, x30, [sp], 16
			ret
		
		
// main: create two nested structure n1 and n2		
		alloc = -(16 + nested_struct_size*2) & -16
		dealloc = -alloc
		n1_s = 16
		n2_s = n1_s + nested_struct_size
		.global main
main: 	stp		x29, x30, [sp, alloc]!
		mov		x29, sp
		// initialize n1 and n2
		add		x8, x29, n1_s
		bl		init
		add 	x8, x29, n2_s
		bl		init
		// print n1 and n2
		add		x0, x29, n1_s
		bl		printstruct
		add		x0, x29, n2_s
		bl		printstruct
		// modify n1
		add		x0, x29, n1_s
			mov		w1, 1
		mov		w2, 2
		mov		w3, 3  
		mov		x4, 4
		mov		x5, 5
		bl		modifystruct
		// print n1
		add		x0, x29, n1_s
		bl 		printstruct
		// return
		ldp		x29, x30, [sp], dealloc
		ret

