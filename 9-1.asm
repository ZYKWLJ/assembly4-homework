;编程：满屏全部显示红底绿字闪烁的'1'
assume cs:codesg

codesg segment 
start:	
    ;从B800:00-B800:9F,一直循环80次，一行共80个字符，那么满屏就是80*26个字符(最上面的一行会被覆盖)
    mov cx, 80*25      ;十进制的80
    ;mul cx, 25       ;满屏都是'1'
    mov ax, 0B800h   ;基地址
    mov es, ax       ;es指向显存
    mov bx, 160     ;第二行开始显示，因为会向上滑动，导致第一行看不见
    
    mov ah, 11000010b ;红底绿字属性：11000010b
    mov al, 49      ;设置字符为'1'，十进制的49
    
s0:
    mov es:[bx], ax  ;将字符和属性写入显存
    add bx, 2        ;每个字符占用两个字节
    loop s0
    
    mov ax, 4c00h 
    int 21h 
codesg ends 
end start 