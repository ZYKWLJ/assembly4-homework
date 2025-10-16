assume cs:code
code segment
start:
    mov ax,0b800h
    mov es,ax		
    mov bx,0h     ;es:bx数据准备读到硬盘中去
    
    mov al,8	;写入8个扇区
    mov ch,0	;磁道号
    mov cl,1	;起始扇区号
    mov dl,80h	;驱动器号
    mov dh,0	;磁头号
    mov ah,3	;写硬盘
    int 13h
    
    ; 清屏（保护寄存器）
    push es
    push bx
    mov cx,2000        ; 2000个字符，不是4000
    mov ax,0b800h
    mov es,ax
    mov di,0
clean:
    mov byte ptr es:[di],' '
    mov byte ptr es:[di+1],11000010b
    add di,2           ; 使用add而不是两次inc
    call delay
    loop clean
    pop bx
    pop es

    ; 现在再将硬盘中的数据读到es:bx处
    mov ax,0b800h
    mov es,ax		
    mov bx,160*12     ; 读取到屏幕第13行
    
    mov al,8	; 读取8个扇区
    mov ch,0	; 磁道号
    mov cl,1	; 扇区号
    mov dl,80h	; 驱动器号
    mov dh,0	; 磁头号
    mov ah,2	; 读硬盘
    int 13h

    mov ax,4c00h
    int 21h

delay:
    push ax
    push cx
    mov cx,00005h
delay_outer:
    mov ax,00005h
delay_inner:
    dec ax
    jnz delay_inner
    loop delay_outer
    pop cx
    pop ax
    ret

code ends
end start