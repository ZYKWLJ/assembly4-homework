assume cs:code,ds:data

data segment
    prompt db 'LinLin>','$'
    buffer db 1000 dup(0)
    top    dw 0        ; 将top移到数据段
data ends

code segment

start:
    mov ax, data
    mov ds, ax
    mov si, offset buffer  ; 使用offset明确指定buffer位置

getstr:
; 每次输入字符前，都要先打印prompt `linlin`
prompt_display:
    mov dx, offset prompt  ; 显示提示符
    mov ah, 9
    int 21h

getstrs:
    mov ah, 0
    int 16h         ; 使用int 16读取键盘缓冲区的数据
    
    cmp al, 20h     ; 对键入的字符进行判断，看是不是可视化字符？
    jb nochar       ; 不是字符，查看是不是删除或者enter
    
    ; 是字符，先入栈
    mov ah, 0
    call charstack
    ; 再显示
    mov ah, 2
    call charstack
    jmp getstrs     ; 继续循环等待输入


;==不是字符的情况处理==
nochar:
    cmp ah, 0eh     ; 退格键
    je backspace
    cmp ah, 1ch     ; 回车键
    je enter_key
    jmp getstrs     ; 其他键忽略，继续读取

backspace:
    mov ah, 1
    call charstack  ; 字符出栈
    mov ah, 2
    call charstack  ; 显示栈中的字符
    jmp getstrs     ; 继续读取


enter_key:          ; 输入结束
    ; 检查退出条件 - 如果输入的是单个字符'q'
    cmp top, 1
    jne not_quit
    mov bx, 0
    mov al, [si+bx]     ; 获取栈中第一个字符
    cmp al, 'q'
    je do_quit
    cmp al, 'Q'         ; 也检查大写Q
    je do_quit

not_quit:
    ; 获取当前光标位置
    mov ah, 3
    mov bh, 0
    int 10h
    ; dh = 行号, dl = 列号
    
    ; 换到下一行
    inc dh          ; 行号+1
    mov dl, 0       ; 列号归0
    mov ah, 2
    int 10h         ; 先将光标移到新行的行首
    
    ; 检查是否需要屏幕滚动（如果到达底部）
    cmp dh, 25      ; 通常80x25文本模式
    jb no_scroll
    ; 调用滚动功能
    mov ah, 6       ; 向上滚动
    mov al, 1       ; 滚动1行
    mov bh, 7       ; 属性
    mov ch, 0       ; 左上角行
    mov cl, 0       ; 左上角列  
    mov dh, 24      ; 右下角行
    mov dl, 79      ; 右下角列
    int 10h
    mov dh, 24      ; 设置到新底部行
    
no_scroll:
    ; 重置栈指针
    mov top, 0
    
    ; 先将光标移到行首，再显示提示符
    mov ah, 2
    mov bh, 0
    mov dl, 0
    int 10h
    
    jmp getstr      ; 重新开始输入

do_quit:
    ; 返回DOS
    mov ax, 4c00h
    int 21h


; 字符栈子程序实现
charstack: 
    jmp short charstart
  
;直接定址表表项内容(存放着3个字符栈的操作)
table   dw charpush, charpop, charshow

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
    cmp top, 1000   ; 防止缓冲区溢出
    jae push_ret
    mov bx, top
    mov [si+bx], al
    inc top
push_ret:
    jmp sret

; 出栈子程序
charpop: 
    cmp top, 0
    je sret
    dec top
    mov bx, top
    mov al, [si+bx]
    jmp sret

; 显示子程序
charshow:
    ; 保存当前光标位置
    mov ah, 3
    mov bh, 0
    int 10h
    push dx         ; 保存光标位置
    
    ; 移动到提示符后的位置开始显示
    mov ah, 2
    mov bh, 0
    mov dl, 7       ; "LinLin>" 长度是7，所以从第7列开始
    int 10h
    
    ; 显示所有栈中的字符
    mov bx, 0
    cmp bx, top
    je show_cursor  ; 如果栈空，只显示光标
    
display_loop:
    cmp bx, top
    jae display_done
    
    mov al, [si+bx]
    mov ah, 0Eh     ; BIOS 电传打字输出。模拟老式电传打字机（Teletype）的字符输出方式，每输出一个字符后，光标自动向右移动一格，当光标到达行尾时，自动移动到下一行行首。当光标到达屏幕底部时，整个屏幕向上滚动一行，输出字符时保持当前颜色和属性设置。
    int 10h
    inc bx
    jmp display_loop

display_done:
    ; 显示闪烁光标（下划线）
    mov al, ' '
    mov ah, 0Eh
    int 10h

show_cursor:
    ; 恢复光标位置到输入末尾
    pop dx
    mov ah, 2
    mov bh, 0
    ; 计算新的列位置：7 + 字符数
    mov dl, 7
    add dl, byte ptr top
    int 10h
    
sret: 
    pop ax
    pop es
    pop di
    pop dx
    pop bx
    ret
    
code ends
end start 