obj=src/.obj/
zero=src/.zero/
kit=src/.kit/
build=build/
source=src/zero/HD.img
target=build/HD.img
defualt:
	nasm -f bin src/boot/mbr.S -o $(obj)mbr.bin
	nasm -f bin src/init/loader.S -o $(obj)loader.bin
	cp $(source) $(target)
	dd if=$(obj)mbr.bin of=$(target) bs=512 count=1 conv=notrunc
	dd if=$(obj)loader.bin of=$(target) bs=512 seek=1 conv=notrunc

	