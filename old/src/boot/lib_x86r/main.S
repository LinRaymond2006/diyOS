;===========================================
;created by LinRaymond2006@gmail.com
;description:
;a standard library in real mode
;
;
;
;===========================================

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



;eax:sector offset
;bx:buffer location
;cx:number of sectors to read
read_lba24_x86r:
	mov esi, eax
	mov di, cx
	mov dx, 0x1f2
	mov al, cl
	out dx, al 		;how many sectors to read
	mov eax, esi
	mov dx, 0x1f3
	out dx, al  	;LBAddr 0~7
	mov cl, 8
	shr eax, cl
	mov dx, 0x1f4
	out dx, al  	;LBAddr 8~15
	shr eax, cl
	mov dx, 0x1f5
	out dx, al  	;LBAddr 16~23
	shr eax, cl
	and al, 0xe0    ;bit7~bit4=1110->using LBA
	or al, 0xe0
	mov dx, 0x1f6
	out dx, al
	mov dx, 0x1f7
	mov al, 0x20
	out dx, al  	;0x20->read

.diskstat_busy: ;write->command word port. read->disk status
	nop
	in al, dx
	and al, 0x88  ;bit3=1->ready, bit7=1->disk in busy
	cmp al, 0x08
	jnz .diskstat_busy
	mov ax, di
	mov dx, 256
	mul dx
	mov cx, ax
	;di=loader_sect_size, each sector is composed by 512 bytes
	;therefore need di*512/2 times to finish the operation(2bytes comprise a word)
	mov dx, 0x1f0
.contrd:
	in ax, dx
	mov [bx], ax
	add bx, 2
	loop .contrd
	ret


enA20_fastgate:
	in al, 0x92
	or al, 00000010b
	out 0x92, al
	ret