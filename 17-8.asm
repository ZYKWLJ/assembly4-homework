assume cs:code
code segment
start:
    ; 使用更安全的扇区（比如从第10扇区开始）
    mov ax, 0b800h
    mov es, ax        
    mov bx, 0
    
    ; 尝试写入非系统扇区
    mov al, 1          ; 只写1个扇区测试
    mov ch, 0          ; 磁道号
    mov cl, 10         ; 从第10扇区开始（避开系统区）
    mov dl, 80h        ; 驱动器
    mov dh, 0          ; 磁头
    mov ah, 3          ; 写功能
    int 13h
    jc failed
    
    ; 清屏
    mov cx, 2000
    mov di, 0
clean:
    mov byte ptr es:[di], ' '
    mov byte ptr es:[di+1], 02h
    add di, 2
    loop clean
    
    ; 读取回来
    mov bx, 160*10
    mov al, 1
    mov ch, 0
    mov cl, 10
    mov dl, 80h
    mov dh, 0
    mov ah, 2
    int 13h
    jc failed
    
    mov ax, 4c00h
    int 21h

failed:
    ; 显示失败信息
    mov ax, 0b800h
    mov es, ax
    mov byte ptr es:[0], 'F'
    mov byte ptr es:[1], 04h
    mov ax, 4c01h
    int 21h

code ends
end start