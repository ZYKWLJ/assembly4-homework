assume cs:code
code segment
start:
    ; 在屏幕上显示原始内容
    mov ax, 0b800h
    mov es, ax
    mov di, 0
    mov cx, 80
    mov al, 'H'
    mov ah, 07h
init_loop:
    mov es:[di], ax
    add di, 2
    inc al
    loop init_loop
    
    ; 保存屏幕内容到内存缓冲区 (0:1000h)
    mov ax, 0
    mov ds, ax
    mov si, 0b800h
    mov es, si
    mov di, 1000h      ; 目标缓冲区
    mov si, 0          ; 源显存
    mov cx, 2000       ; 4000字节
    cld
    rep movsb
    
    ; 清屏（动画效果）
    mov ax, 0b800h
    mov es, ax
    mov di, 0
    mov cx, 2000
clean_loop:
    mov byte ptr es:[di], ' '
    mov byte ptr es:[di+1], 02h  ; 绿字
    add di, 2
    call delay_short
    loop clean_loop
    
    ; 等待按键
    mov ah, 0
    int 16h
    
    ; 从内存缓冲区恢复到屏幕第12行
    mov ax, 0
    mov ds, ax
    mov si, 1000h      ; 源缓冲区
    mov ax, 0b800h
    mov es, ax
    mov di, 160*12     ; 目标：第13行
    mov cx, 2000
    cld
    rep movsb
    
    ; 等待按键退出
    mov ah, 0
    int 16h
    
    mov ax, 4c00h
    int 21h

delay_short:
    push cx
    mov cx, 1000
delay_loop:
    loop delay_loop
    pop cx
    ret

code ends
end start