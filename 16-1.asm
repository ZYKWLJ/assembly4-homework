assume cs:code, ds:data

data segment
    table db '0123456789ABCDEF' ; 字符表
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    
    ; 测试显示不同字节
    mov al, 1Bh      ; 显示 "1B"
    call showbyte
    
    mov ax, 4c00h
    int 21h


; 子程序：显示AL中的字节（十六进制）
showbyte: 
    push bx
    push es
    push ax
    
    mov ah, al          ; 保存原始值 
mov cl, 4
shr ah, cl ; 右移4位获取高4位

    and al, 00001111b   ; 获取低4位
    mov bx, 0b800h
    mov es, bx
    
    ; 显示高4位（绿色）
    mov bl, ah
    mov bh, 0
    mov dl, table[bx]   ; 字符
    mov dh, 02h         ; 颜色属性（绿色）
    mov es:[160*24], dx
    
    ; 显示低4位（红色）  
    mov bl, al
    mov bh, 0
    mov dl, table[bx]   ; 字符
    mov dh, 04h         ; 颜色属性（红色）
    mov es:[160*24+2], dx
    
    pop ax
    pop es
    pop bx
    ret

code ends
end start  