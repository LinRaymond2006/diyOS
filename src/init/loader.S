;===========================================
;created by LinRaymond2006@gmail.com
;description:
;the loader will be loaded into 0x500, 
;which is the lowest convincial memory
;
;
;===========================================
%include "src/memory_position/mempos.S"
section loader vstart=loader_mem_position
	jmp start
	%include "src/memory_position/mempos.S"
	%include "src/init/gdt_attr_x86p.S"
	%include "src/boot/lib_x86r/main.S"

	;;;;;;;;;;;;;;;;;;following are global descriptor;;;;;;;;;;;;;;;;;;
	;   .----------------.  .----------------.  .----------------.    ;
  	;   | .--------------. || .--------------. || .--------------. |  ;
	;   | |    ______    | || |  ________    | || |  _________   | |  ;
	;   | |  .' ___  |   | || | |_   ___ `.  | || | |  _   _  |  | |  ;
	;   | | / .'   \_|   | || |   | |   `. \ | || | |_/ | | \_|  | |  ;
	;   | | | |    ____  | || |   | |    | | | || |     | |      | |  ;
	;   | | \ `.___]  _| | || |  _| |___.' / | || |    _| |_     | |  ;
  	;   | |  `._____.'   | || | |________.'  | || |   |_____|    | |  ;
	;   | |              | || |              | || |              | |  ;
	;   | '--------------' || '--------------' || '--------------' |  ;
	;   '----------------'  '----------------'  '----------------'    ; 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	gdt_base:		dd 0x00000000
					dd 0x00000000

	code_segdesc:	dd 0x0000ffff
					dd desc_code_high

	data_segdesc:	dd 0x0000ffff
					dd desc_data_high

	vmem_segdesc:	dd vmem_limit
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

	start:
		call enA20_fastgate
		lgdt [gdt_pointer]
		mov eax, cr0
		or eax, 0x00000001
		mov eax, cr0
		jmp code_selector:pmode_entry


	[bits 32]
	pmode_entry:
		mov ax, data_selector
		mov ds, ax
		mov es, ax
		mov ss, ax
		mov esp, p_loader_stack_position
		mov ax, video_selector
		mov gs, ax
		jmp $