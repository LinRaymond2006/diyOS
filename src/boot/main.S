section handler vstart=0x7c00
	stacktop_tmp equ 0x7c00

	;entry point, do not modify
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov fs, ax
	mov sp, stacktop_tmp
	
	;library/macro/include here

	%include "src/boot/lib_x86r/main.S"
	%include "src/memory_position/mempos.S"
	
	;code here

	call detect_svga_support
	mov eax, loader_sect_offset
	mov bx, loader_mem_position
	mov cx, loader_sect_size
	call read_lba24_x86r
	jmp loader_mem_position


	times 510-($-$$) db 0
	;create GUID table here someday
	db 0x55, 0xaa
