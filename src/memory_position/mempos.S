;===========================================
;created by LinRaymond2006@gmail.com
;description:
;this file defines macros
;do not define anything except macro here
;
;
;===========================================

%define loader_mem_position 0x1000
%define loader_stack_position loader_mem_position
%define p_loader_stack_position loader_stack_position   ;stck of loader in protected mode is same as real mode
%define loader_stack_size loader_mem_position - 0x500	;500bytes of memory should be enought for the stack 
														;of the loader(first convincial memory starts from 0x500)
%define loader_sect_offset 0x1
%define loader_sect_size 0x1 							;as the loader becomes larger, this value may increase
														;loader_sect_size = roundup(loader_size/512)
%define video_mem_position 0xa0000
%define svga_col 0x5a0		;1440
%define svga_row 0x384		;900
%define svga_pixle_size 0x2	;32bits=2bytes
%define svga_videomem_size svga_pixle_size*(svga_col*svga_row)	;supposed to be 0x278d00 in svga 0x180 mode
																;32bit=2(bytes)
																;1440(column)*900(row)=1296000(pixle)
																;1296000(pixle)*2(bytes/per pixle)=2592000(bytes)
%define vmem_limit svga_videomem_size