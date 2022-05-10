nasmbin=nasm -f bin
nasmelf=nasm -f elf
src=src/
obj=.obj/
build=build/
kit=.kit/
zero=hdimages/HD.img
tmp_img=build/HD.img
block_size_of=$(shell python3 $(kit)get_fileblock.py )#require a filename here
defualt:
	$(nasmbin) $(src)boot/main.S -o $(obj)main.bin
	$(nasmbin) $(src)init/loader.S -o $(obj)loader.bin
	cp $(zero) $(build)HD.img
	dd if=$(obj)main.bin of=$(tmp_img) bs=512 count=1 conv=notrunc
	dd if=$(obj)loader.bin of=$(tmp_img) bs=512 seek=2 conv=notrunc
	echo ***done***
	#use "block_size_of" command

test:
	qemu-system-i386 -fda build/test.disk
clean:
	rm -rf $(build)*