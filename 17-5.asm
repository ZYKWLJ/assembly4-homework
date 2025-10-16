;读取0磁面0磁道1扇区的数据写到es:bx
assume cs:code
code segment
start:
	mov ax,0
	mov es,ax		
	mov bx,200h     ;es:bx指向接受从扇区读入数据的内存区
	
	mov al,1	;读取一个扇区
	mov ch,0	;读取的磁道号
	mov cl,1	;读取的扇区起始号
	mov dl,80h	;驱动器号 软驱从0开始，0代表软驱A，1代表软驱B；硬盘从80h开始，80h硬盘C，81h，硬盘D
	mov dh,0	;磁头号(对于软盘来说就是面号，因为一个面用一个磁头来读写)
	mov ah,2	;从硬盘读数据的功能号为2
	int 13h

	mov ax,4c00h
	int 21h

code ends
end start