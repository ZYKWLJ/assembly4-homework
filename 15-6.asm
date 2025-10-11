; 在DOSBox 80x25模式下显示HUAWEI
; H-U-A-W-E各占15列，I占5列

code segment
    assume cs:code, ds:code
    org 100h

start:
    ; 设置80x25文本模式
    mov ax, 0003h
    int 10h
    
    ; 设置数据段
    mov ax, cs
    mov ds, ax
    
    ; 隐藏光标
    mov ah, 01h
    mov cx, 2000h
    int 10h
    
    ; 设置颜色并清屏
    mov ax, 0600h    ; AH=06h (滚动窗口), AL=00h (清屏)
    mov bh, 17h      ; 蓝底白字
    mov cx, 0000h    ; 左上角 (0,0)
    mov dx, 184Fh    ; 右下角 (79,24)
    int 10h
    
    ; 显示H (第1-15列)
    call display_H
    
    ; 显示U (第16-30列)
    call display_U
    
    ; 显示A (第31-45列)
    call display_A
    
    ; 显示W (第46-60列)
    call display_W
    
    ; 显示E (第61-75列)
    call display_E
    
    ; 显示I (第76-80列)
    call display_I
    
    ; 等待按键
    mov ah, 00h
    int 16h
    
    ; 返回DOS
    mov ax, 4C00h
    int 21h

; 显示字母H (15列宽度)
display_H proc
    mov cx, 7        ; 7行高度
    mov row, 9       ; 起始行
    
h_loop:
    push cx
    
    ; 设置光标位置
    mov ah, 02h
    mov bh, 00h
    mov dh, row      ; 行
    mov dl, 2        ; 列 (在15列范围内居中)
    int 10h
    
    ; 根据行数显示不同内容
    mov cx, 1        ; 显示1个字符
    
    cmp row, 9       ; 第一行
    je h_top
    cmp row, 15      ; 最后一行
    je h_bottom
    jmp h_middle
    
h_top:
    mov al, 219      ; 实心方块
    jmp h_print
    
h_bottom:
    mov al, 219      ; 实心方块
    jmp h_print
    
h_middle:
    mov al, 219      ; 实心方块
    
h_print:
    mov ah, 09h
    mov bl, 0F0h     ; 黑底白字高亮
    int 10h
    
    ; 在右侧也显示
    mov ah, 02h
    mov dl, 12       ; 右侧位置
    int 10h
    
    mov ah, 09h
    int 10h
    
    ; 中间竖线
    mov ah, 02h
    mov dl, 7        ; 中间位置
    int 10h
    
    mov ah, 09h
    int 10h
    
    inc row
    pop cx
    loop h_loop
    ret
display_H endp

; 显示字母U (15列宽度)
display_U proc
    mov cx, 7        ; 7行高度
    mov row, 9       ; 起始行
    
u_loop:
    push cx
    
    ; 设置光标位置
    mov ah, 02h
    mov bh, 00h
    mov dh, row      ; 行
    mov dl, 17       ; 列 (在15列范围内居中)
    int 10h
    
    ; 根据行数显示不同内容
    mov cx, 1        ; 显示1个字符
    
    cmp row, 15      ; 最后一行
    je u_bottom
    jmp u_side
    
u_side:
    mov al, 219      ; 实心方块
    jmp u_print
    
u_bottom:
    mov al, 219      ; 实心方块
    
u_print:
    mov ah, 09h
    mov bl, 0F0h     ; 黑底白字高亮
    int 10h
    
    ; 在右侧也显示
    mov ah, 02h
    mov dl, 27       ; 右侧位置
    int 10h
    
    mov ah, 09h
    int 10h
    
    ; 如果是最后一行，填充底部横线
    cmp row, 15
    jne u_skip_bottom
    
    mov cx, 9        ; 中间9个字符
    mov dl, 18       ; 起始列
u_bottom_loop:
    mov ah, 02h
    int 10h
    
    mov ah, 09h
    int 10h
    
    inc dl
    loop u_bottom_loop
    
u_skip_bottom:
    inc row
    pop cx
    loop u_loop
    ret
display_U endp

; 显示字母A (15列宽度)
display_A proc
    mov cx, 7        ; 7行高度
    mov row, 9       ; 起始行
    
a_loop:
    push cx
    
    ; 设置光标位置
    mov ah, 02h
    mov bh, 00h
    mov dh, row      ; 行
    mov dl, 32       ; 列 (在15列范围内居中)
    int 10h
    
    mov al, 219      ; 实心方块
    mov cx, 1
    mov bl, 0F0h     ; 黑底白字高亮
    
    ; 显示左侧竖线
    mov ah, 09h
    int 10h
    
    ; 显示右侧竖线
    mov ah, 02h
    mov dl, 42
    int 10h
    
    mov ah, 09h
    int 10h
    
    ; 如果是中间行，显示横线
    cmp row, 11
    jne a_skip_middle
    
    mov cx, 9        ; 中间9个字符
    mov dl, 33       ; 起始列
a_middle_loop:
    mov ah, 02h
    int 10h
    
    mov ah, 09h
    int 10h
    
    inc dl
    loop a_middle_loop
    
a_skip_middle:
    inc row
    pop cx
    loop a_loop
    ret
display_A endp

; 显示字母W (15列宽度)
display_W proc
    mov cx, 7        ; 7行高度
    mov row, 9       ; 起始行
    
w_loop:
    push cx
    
    ; 设置光标位置
    mov ah, 02h
    mov bh, 00h
    mov dh, row      ; 行
    mov dl, 47       ; 列 (在15列范围内居中)
    int 10h
    
    mov al, 219      ; 实心方块
    mov cx, 1
    mov bl, 0F0h     ; 黑底白字高亮
    
    ; 显示左侧竖线
    mov ah, 09h
    int 10h
    
    ; 显示右侧竖线
    mov ah, 02h
    mov dl, 57
    int 10h
    
    mov ah, 09h
    int 10h
    
    ; 根据行数显示中间部分
    cmp row, 13
    jl w_skip_middle
    cmp row, 15
    jg w_skip_middle
    
    ; 显示中间两个点
    mov ah, 02h
    mov dl, 51
    int 10h
    
    mov ah, 09h
    int 10h
    
    mov ah, 02h
    mov dl, 53
    int 10h
    
    mov ah, 09h
    int 10h
    
w_skip_middle:
    inc row
    pop cx
    loop w_loop
    ret
display_W endp

; 显示字母E (15列宽度)
display_E proc
    mov cx, 7        ; 7行高度
    mov row, 9       ; 起始行
    
e_loop:
    push cx
    
    ; 设置光标位置
    mov ah, 02h
    mov bh, 00h
    mov dh, row      ; 行
    mov dl, 62       ; 列 (在15列范围内居中)
    int 10h
    
    mov al, 219      ; 实心方块
    mov cx, 1
    mov bl, 0F0h     ; 黑底白字高亮
    
    ; 显示左侧竖线
    mov ah, 09h
    int 10h
    
    ; 根据行数显示横线
    cmp row, 9       ; 顶行
    je e_top
    cmp row, 12      ; 中间行
    je e_middle
    cmp row, 15      ; 底行
    je e_bottom
    jmp e_next
    
e_top:
    mov cx, 12       ; 顶部横线
    mov dl, 63
e_top_loop:
    mov ah, 02h
    int 10h
    
    mov ah, 09h
    int 10h
    
    inc dl
    loop e_top_loop
    jmp e_next
    
e_middle:
    mov cx, 8        ; 中间横线
    mov dl, 63
e_middle_loop:
    mov ah, 02h
    int 10h
    
    mov ah, 09h
    int 10h
    
    inc dl
    loop e_middle_loop
    jmp e_next
    
e_bottom:
    mov cx, 12       ; 底部横线
    mov dl, 63
e_bottom_loop:
    mov ah, 02h
    int 10h
    
    mov ah, 09h
    int 10h
    
    inc dl
    loop e_bottom_loop
    
e_next:
    inc row
    pop cx
    loop e_loop
    ret
display_E endp

; 显示字母I (5列宽度)
display_I proc
    mov cx, 7        ; 7行高度
    mov row, 9       ; 起始行
    
i_loop:
    push cx
    
    ; 设置光标位置
    mov ah, 02h
    mov bh, 00h
    mov dh, row      ; 行
    mov dl, 78       ; 列 (在5列范围内居中)
    int 10h
    
    mov al, 219      ; 实心方块
    mov cx, 1
    mov bl, 0F0h     ; 黑底白字高亮
    
    ; 显示竖线
    mov ah, 09h
    int 10h
    
    inc row
    pop cx
    loop i_loop
    ret
display_I endp

; 数据段
row db 0

code ends
end start