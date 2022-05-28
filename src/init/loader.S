;===========================================
;created by LinRaymond2006@gmail.com
;description:
;the loader will be loaded into 0x500, 
;which is the lowest convincial memory
;
;
;===========================================





section loader vstart=loader_mem_position
	jmp start
	
	%define loader_mem_position 0x900
	%define loader_stack_position loader_mem_position
	%define p_loader_stack_position loader_stack_position   ;stck of loader in protected mode is same as real mode
	%define loader_stack_size loader_mem_position - 0x500	;500bytes of memory should be enought for the stack 
															;of the loader(first convincial memory starts from 0x500)
	%define loader_sect_offset 0x1
	%define loader_sect_size 0x3 							;as the loader becomes larger, this value may increase
															;loader_sect_size = roundup(loader_size/512)
	%define video_mem_position 0xa0000
	%define svga_col 0x5a0		;1440
	%define svga_row 0x384		;900
	%define svga_pixle_size 0x2	;32bits=2bytes
	%define svga_videomem_size svga_pixle_size*(svga_col*svga_row)	;supposed to be 0x278d00 in svga 0x180 mode
																	;32bit=2(bytes)
																	;1440(column)*900(row)=1296000(pixle)
																	;1296000(pixle)*2(bytes/per pixle)=2592000(bytes)
	;for SVGA

	%define vmem_limit svga_videomem_size


	;for text

	;%define vmem_limit 0x80000007
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;gdt attributes;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;G:granularity 4kib(1)/byte(0)
	bitG_4KiB				equ 1_00000000000000000000000b

	;D/B:protected mode(1)/real mode(0)
	bitDB_P					equ 1_0000000000000000000000b

	;L:long mode(1)/protected mode(0)
	bitL_P					equ 0_000000000000000000000b

	;AVL:available, CPU will set this flag for the system
	bitAVL					equ 0_00000000000000000000b

	GENERAL_DESC_LIMIT2 	equ 1111_0000000000000000b

	desc_limit_code2		equ GENERAL_DESC_LIMIT2
	desc_limit_data2		equ GENERAL_DESC_LIMIT2
	desc_limit_vmem2		equ 0000_000000000000000b

	;P:present, must be 1 for a valid segment
	bitP 					equ 1_000000000000000b

	;Descriptor privilege level (DPL) is the highest level of 
	;privilege that can access the resource 
	;Requested privilege level (RPL) is defined in the segment 
	;selector, the last two bits, define the privillage of the descriptor

	desc_dpl0				equ 00_0000000000000b
	desc_dpl1				equ 01_0000000000000b
	desc_dpl2				equ 10_0000000000000b
	desc_dpl3				equ 11_0000000000000b

	;S:system segment(0)/(code/data) segment(1)

	GENERAL_USER_SEGMENT 	equ 1_000000000000b

	bitS_code 				equ GENERAL_USER_SEGMENT
	bitS_data 				equ GENERAL_USER_SEGMENT
	bitS_system				equ 0_000000000000b

	;code segment TYPE:executable=1, conformimg=0, readable=0, access=0
	bitTYPE_code			equ 1000_00000000b

	;data segment TYPE:executable=0, conformimg=0, readable=1, access=0
	bitTYPE_data			equ 0010_00000000b

	desc_code_high equ (0x00 << 24) + bitG_4KiB + bitDB_P + bitL_P + bitAVL + desc_limit_code2 + bitP + desc_dpl0 + bitS_code + bitTYPE_code + 0x00

	desc_data_high equ (0x00 << 24) + bitG_4KiB + bitDB_P + bitL_P + bitAVL + desc_limit_data2 + bitP + desc_dpl0 + bitS_data + bitTYPE_data + 0x00

	desc_vmem_high equ (0x00 << 24) + bitG_4KiB + bitDB_P + bitL_P + bitAVL + desc_limit_vmem2 + bitP + desc_dpl0 + bitS_data + bitTYPE_data + 0x00


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;gdt selector attributes;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	rpl0 equ 00b
	rpl1 equ 01b
	rpl2 equ 10b
	rpl3 equ 11b

	;TI:table indicator gdt(0)/LDT(1)
	bitTI_gdt equ 000b
	bitTI_ldt equ 100b

	;;;;;;;;;;;;;;;;;;following are global descriptor;;;;;;;;;;;;;;;;;;

	gdt_base:		dd 0x00000000
					dd 0x00000000

	code_segdesc:	dd 0x0000ffff
					dd desc_code_high

	data_segdesc:	dd 0x0000ffff
					dd desc_data_high

	vmem_segdesc:	dd vmem_limit		;vmem_limit may change
					dd desc_vmem_high

	gdt_size equ $ - gdt_base
	gdt_limit equ gdt_size - 1
	times 60 dq 0 		;60 more segment descriptor can be placed here, but the 
						;value may decrease as the number of descriptors increase

	;here are the segment selector
	code_selector  equ (0x001 << 3) + bitTI_gdt + rpl0
	data_selector  equ (0x002 << 3) + bitTI_gdt + rpl0
	video_selector equ (0x003 << 3) + bitTI_gdt + rpl0

	gdt_pointer dw gdt_limit
				dd gdt_base

	detect_svga_support:
		mov ax, 0x4f02
		mov bx, 0x4180
		int 0x10
		cmp ax, 0x004f
		jnz shutdown_x86r
		ret
	shutdown_x86r:
		mov ax, 0x1000
		mov ax, ss
		mov sp, 0xf000
		mov ax, 0x5307
		mov bx, 0x0001
		mov cx, 0x0003
		int 0x15
	start:
		;call detect_svga_support
		in al, 0x92
		or al, 00000010b
		out 0x92, al
		lgdt [gdt_pointer]
		mov eax, cr0
		or eax, 0x00000001
		mov eax, cr0
		jmp code_selector:pmode_entry
		

	[bits 32]
	pmode_entry:
		;do not modify following
		mov ax, data_selector
		mov ds, ax
		mov es, ax
		mov ss, ax
		mov esp, p_loader_stack_position
		mov ax, video_selector
		mov gs, ax

		;codes here
		

		jmp $