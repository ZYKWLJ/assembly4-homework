assume cs:code

code segment

start:
    mov ax, cs
    mov ds, ax
    mov si, 0
    
getstr:
    push ax

getstrs:
    mov ah, 0
    int 16h         ; 使用int 16读取键盘缓冲区的数据
    
    cmp al, 20h     ; 修正：添加逗号
    jb nochar       ; 不是字符，查看是不是删除或者enter
    mov ah, 0       ; 是字符，先入栈
    call charstack  ; 调用0号功能，字符入栈
    mov ah, 2       ; 再显示
    call charstack  ; 调用2号功能，显示栈中的字符
    jmp getstrs     ; 继续循环等待输入

nochar:
    cmp ah, 0eh
    je backspace
    cmp ah, 1ch
    je enter
    jmp getstrs
    
backspace:
    mov ah, 1
    call charstack  ; 字符出栈
    mov ah, 2
    call charstack  ; 显示栈中的字符
    jmp getstrs     ; 继续读取
    
enter:              ; 输入结束
    mov al, 0
    mov ah, 0
    call charstack  ; 0入栈
    mov ah, 2
    call charstack  ; 显示栈中的字符
    pop ax
    ret

; 字符栈子程序实现
charstack: 
    jmp short charstart

table   dw charpush, charpop, charshow
top     dw 0

charstart: 
    push bx
    push dx
    push di
    push es
    push ax

    cmp ah, 2
    ja sret

    mov bl, ah
    mov bh, 0
    add bx, bx
    jmp word ptr table[bx]

; 入栈子程序
charpush: 
    mov bx, top         ; 修正：使用英文分号
    mov [si][bx], al    ; 将al中的字符存入栈中
    inc top             ; 栈顶指针加1
    jmp sret

; 出栈子程序
charpop: 
    cmp top, 0          ; 判断栈是否为空
    je sret             ; 栈空则返回
    dec top             ; 栈顶指针减1
    mov bx, top
    mov al, [si][bx]    ; 将栈顶字符存入al中
    jmp sret

; 显示子程序
charshow: 
    mov bx, 0b800h      ; 显存段地址
    mov es, bx
    mov al, 160
    mov ah, 0           ; 修正：使用ah而不是dh
    mul dh              ; 计算行偏移(160*dh)
    mov di, ax          ; 将行偏移存入di
    
    mov al, 2
    mul dl              ; 计算列偏移(2*dl)
    add di, ax          ; di = 行偏移 + 列偏移
    
    mov bx, 0

charshowes: 
    cmp bx, top         ; 判断是否显示完所有字符
    jne noempty         ; 还有字符，就显示！
    mov byte ptr es:[di], ' '   ; 栈空则显示空格
    jmp sret

noempty: 
    mov al, [si][bx]    ; 取出字符
    mov es:[di], al     ; 显示字符
    mov byte ptr es:[di+2], ' ' ; 清除下一个位置的残留字符
    inc bx
    add di, 2           ; 移动到下一个显示位置
    jmp charshowes

sret: 
    pop ax              ; 修正：恢复寄存器的顺序要与push相反
    pop es
    pop di
    pop dx
    pop bx
    ret

code ends
end start