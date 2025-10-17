;简单的，打印一个除数、被除数的商、余数到屏幕上来！
assume cs:code
code segment
start:
	;安装中断程序
	call set7c
	;传递中断的参数
	mov bx,80
	mov dx,389;总的数

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
	mov cx, offset endint7c-offset int7c

	cld
	rep movsb;将中断程序写到0000:0200处

	;再将地址赋到0000:007c处
	mov ax,0000h
	mov ds,ax
	mov di,4*007ch
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

	;用bx来进行传参表示除法，ax表示商，dx表示总数
	mov ax,0
	call divide

	; 将商转换为ASCII字符显示
	add al, '0'  ; 转换为ASCII码
	
	mov bx,0b800h
	mov es,bx
	mov byte ptr es:[320], 'A'
	mov byte ptr es:[321], 11001010B

	pop dx
	pop bx
	pop cx
	pop di
	pop ds
	iret

; 除法子程序：dx ÷ bx，结果商存ax
divide:
    push cx      ; 保存cx
    push dx      ; 保存原始dx值
    
    mov cx, dx   ; 将被除数保存到cx
    mov ax, 0    ; 商清零
    mov dx, 0    ; 高位清零
    
divide_loop:
    cmp cx, bx   ; 比较被除数和除数
    jl divide_end ; 如果被除数 < 除数，结束
    
    sub cx, bx   ; 被除数 = 被除数 - 除数
    inc ax       ; 商+1
    jmp divide_loop
    
divide_end:
    pop dx       ; 恢复原始dx值
    pop cx       ; 恢复cx
    ret

endint7c:
	nop	;占位符

code ends
end start