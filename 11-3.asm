; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/zIqzs8bTznrADBujIdi_EQ   #    
; #                                                               #
; #################################################################

;编程，测试flag寄存器的df位变化,功能是将字符串的所有字符复制到其后面。

assume cs:codesg, ds:datasg

datasg segment
    db 'hello world!';注意后面不能多一个,
    db 16 dup(0)
datasg ends

codesg segment
start_:
    ;首先需要找到字符串末尾，显然，使用循环判断是不是为0
    mov cx, 0
    mov si, 0
    mov ax, datasg
    mov ds, ax

find_end:
    mov al, [si]
    cmp al, 0
    je find_ok
    inc si
    jmp find_end

find_ok:
    ; 找到字符串末尾，si指向字符串末尾的下一个位置
    ; 现在需要将si指向字符串的第一个字符
    mov cx,si
    mov ax,ds;
    mov es,ax;
    mov di,cx;
    mov si,0;
    rep movsb ;核心，等价于mov es:[di], byte ptr ds:[si]
    
end_: 
    mov ax, 4c00h 
    int 21h 
codesg ends
end start_