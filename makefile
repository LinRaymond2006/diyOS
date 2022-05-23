nasmbin=nasm -f bin
nasmelf=nasm -f elf
src=src/
obj=.obj/
build=build/
kit=.kit/
zero=hdimages/HD.img
tmp_img=build/HD.img
kernel_seek=0
#block_size_of=$(shell python3 $(kit)get_fileblock.py path_to_the_file)
defualt:
	$(nasmbin) $(src)boot/main.S -o $(obj)main.bin
	$(nasmbin) $(src)init/loader.S -o $(obj)loader.bin
	#compile kernel to kernel.bin here
	cp $(zero) $(build)HD.img
	dd if=$(obj)main.bin of=$(tmp_img) bs=512 count=1 conv=notrunc
	dd if=$(obj)loader.bin of=$(tmp_img) bs=512 seek=2 conv=notrunc
#	$(kernel_seek)=$(shell python3 $(kit)get_fileblock.py $(obj)kernel.bin)+1
#	dd if=$(obj)kernel.bin of=$(tmp_img) bs=512 seek=$(kernel_seek) conv=notrunc

	echo ***done***

test:
	qemu-system-i386 -drive format=raw,file=build/test.disk
clean:
	rm -rf $(build)*
setup_env:
	sudo apt install nasm gcc qemu-system* python3 python3-venv python3-pip