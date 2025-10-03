; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/bcSHDcmVTru43nXcUGrWog   #    
; #                                                               #
; #################################################################
;编程：实现将以0结尾的字符串全部转为大写
assume cs:codesg, ds:datasg

datasg segment 
    db 'Welcome to Linux',0    ; 以0结尾的字符串数据
datasg ends 

codesg segment
start:
    mov ax, datasg
    mov ds, ax              ; ds指向数据段
    mov si, 0               ; 源字符串偏移
    mov cx, 0               ; 长度计数器
    
; 计算字符串长度
word_length:
    cmp byte ptr [si], 0    ; 与0比较
    je ok                   ; 如果等于0就跳转
    inc cx                  ; 长度加1
    inc si                  ; 下一个字符
    jmp word_length

ok:
    ; di指向原数据结束位置的下一个字节（0之后）
    mov di, si
    mov si, 0               ; 重置源指针
    
; 转换并存储到新位置
change:
    mov al, [si]            ; 只读取一个字节
    and al, 11011111b       ; 转换为大写
    mov [di], al            ; 存储到新位置
    inc si
    inc di
    loop change
    
    ; 在新字符串末尾添加0
    mov byte ptr [di], 0

    mov ax, 4c00h 
    int 21h 

codesg ends
end start