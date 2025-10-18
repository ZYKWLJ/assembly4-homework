assume cs:code
code segment
start:
	;安装中断程序
	call set7c
	;传递中断的参数
	mov bx,80
	mov dx,329;总的数

	int 7ch

	mov ax,4c00h
	int 21h

set7c:
	push ds
	push di
	push cx
	mov ax,cs;源地址段地址
	mov ds,ax;
	mov si,offset int7c;源地址偏移地址
	mov ax,0000h
	mov es,ax
	mov di,0200h;目的地址偏移地址	
	mov cx, offset int7c_end - offset int7c

	cld
	rep movsb;将中断程序写到0000:0200处

	;再将地址赋到0000:007c处
	mov ax,0000h
	mov ds,ax
	mov di,7ch*4        ; 修正：7ch * 4 = 1F0h
	mov word ptr [di],0200h		;偏移地址
	mov word ptr [di+2],0000h	;段地址
	
	pop cx
	pop di	
	pop ds
	ret
	
int7c:	;intc7中断程序
	push ds
	push di
	push cx
	push bx
	push dx
	push es

	mov ax,0b800h
	mov es,ax
	mov di,160

	call divide
	

	;先显示商
	add ax, '0'          ;显示为ascii
	mov byte ptr es:[di], al
	mov byte ptr es:[di+1], 11000010b      ;红底绿字属性：11000010b
	add di,2

	;先中间空格
	mov ax, ' '          ;显示为ascii
	mov byte ptr es:[di], al
	mov byte ptr es:[di+1], 11000010b      ;红底绿字属性：11000010b
	add di,2

	;在显示余数
	add 	dx, '0'          ;显示为ascii
	mov byte ptr es:[di], dl
	mov byte ptr es:[di+1], 11000010b      ;红底绿字属性：11000010b
	
	pop es
	pop dx
	pop bx
	pop cx
	pop di
	pop ds
	iret

;除法，被除数在dx，除数在bx，商在ax，余数在dx(剩下的就是它了)
divide:
	mov ax,0
cmp1:
	cmp dx,bx
	jl enddivide
	inc ax
	sub dx,bx
	jmp cmp1
enddivide:	
	ret

int7c_end:  ; 标记中断程序结束
	nop

code ends
end start