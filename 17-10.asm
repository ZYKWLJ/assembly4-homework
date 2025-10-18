assume cs:code
code segment
start:
    ;安装中断程序
    call set7c
    
    mov dx,2879    ; 传递逻辑扇区编号 (0-2879)

    int 7ch

    mov ax,4c00h
    int 21h

set7c:
    push ds
    push di
    push cx
    mov ax,cs              ; 源地址段地址
    mov ds,ax
    mov si,offset int7c    ; 源地址偏移地址
    mov ax,0000h
    mov es,ax
    mov di,0200h           ; 目的地址偏移地址	
    mov cx, offset int7c_end - offset int7c

    cld
    rep movsb              ; 将中断程序写到0000:0200处

    ; 设置中断向量表
    mov ax,0000h
    mov ds,ax
    mov di,7ch*4
    mov word ptr [di],0200h    ; 偏移地址
    mov word ptr [di+2],0000h  ; 段地址
    
    pop cx
    pop di	
    pop ds
    ret
    
int7c:    ; int7ch中断程序
    push ds
    push di
    push cx
    push bx
    push dx
    push es
    push ax
    push si

    mov ax,0b800h
    mov es,ax
    mov di,160              ; 显示位置

    ; 第一次除法：计算磁面号 (0或1)
    ; 磁面号 = 逻辑扇区号 / (80磁道 * 18扇区)
    mov ax,dx              ; AX = 逻辑扇区号
    mov bx,80*18           ; 每个磁面的扇区数
    mov dx,0
    div bx                 ; AX = 磁面号, DX = 剩余扇区数
    
    ; 显示磁面号
    push dx                ; 保存剩余扇区数
    call showNumber        ; 显示磁面号
    pop dx

    ; 第二次除法：计算磁道号 (0-79)
    ; 磁道号 = 剩余扇区数 / 18
    mov ax,dx              ; AX = 剩余扇区数
    mov bx,18              ; 每个磁道的扇区数
    mov dx,0
    div bx                 ; AX = 磁道号, DX = 扇区内偏移(0-17)
    
    ; 显示磁道号
    push dx                ; 保存扇区内偏移
    call showNumber        ; 显示磁道号
    pop dx

    ; 第三次：计算扇区号 (1-18)
    ; 扇区号 = 扇区内偏移 + 1
    mov ax,dx
    inc ax                 ; 扇区号从1开始
    call showNumber        ; 显示扇区号

    pop si
    pop ax
    pop es
    pop dx
    pop bx
    pop cx
    pop di
    pop ds
    iret

; 显示AX中的数字并换行
showNumber:
    push ax
    push bx
    push cx
    push dx
    push di
    
    ; 将数字转换为字符串并显示
    mov bx,10
    mov cx,0
    
    ; 如果数字为0，直接显示
    cmp ax,0
    jne convert_loop
    mov al,'0'
    mov byte ptr es:[di], al
    mov byte ptr es:[di+1], 00001010b  ; 绿字
    add di,2
    jmp show_end
    
convert_loop:
    mov dx,0
    div bx                 ; AX = 商, DX = 余数
    push dx                ; 保存余数（数字字符）
    inc cx                 ; 数字位数计数
    cmp ax,0
    jne convert_loop
    
display_loop:
    pop ax
    add al,'0'
    mov byte ptr es:[di], al
    mov byte ptr es:[di+1], 00001010b  ; 绿字
    add di,2
    loop display_loop
    
show_end:
    pop di
    add di,160             ; 换到下一行
    pop dx
    pop cx
    pop bx
    pop ax
    ret

int7c_end:
    nop

code ends
end start