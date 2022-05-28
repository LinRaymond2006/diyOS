;===========================================
;created by LinRaymond2006@gmail.com
;description:
;the file stores gdt attributes
;do not modify the file
;caution:THIS DESCRIPTOR IS DESIGNED FOR PROTECTED MODE, 
;IT WONT WORK WITH IA32E OR X86LONG
;===========================================


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