; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/VfViroSj3f1jGtpzTVjhBg   #
; #                                                               #            
; #################################################################

;编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串'welcome to masm!'

assume cs:codesg, ds:datasg

datasg segment 
    db 'welcome to masm!'    ; 字符串数据
    db 02h                   ; 绿色字（无背景）
    db 41h                   ; 绿底红字  
    db 14h                   ; 白底蓝字
datasg ends 

codesg segment

start:
    mov ax, datasg
    mov ds, ax              ; ds指向数据段
    
    mov ax, 0B800h
    mov es, ax              ; es指向显存
    
    ; 从第12行开始显示（屏幕中间）
    mov bx, 160 * 12 + 64   ; 第12行，第32列开始
    
    mov si, 0               ; 字符串偏移
    mov di, 16              ; 颜色属性偏移（从第一个颜色开始）
    mov cx, 3               ; 显示3行

; 行循环
row:
    push cx                 ; 保存行循环计数器
    push bx                 ; 保存当前行起始位置
    
    mov cx, 16              ; 字符串长度
    mov ah, [di]            ; 获取颜色属性

; 列循环
column:
    mov al, [si]            ; 获取字符
    mov es:[bx], ax         ; 将字符和属性写入显存
    add bx, 2               ; 每个字符占用两个字节
    inc si                  ; 下一个字符
    loop column             ; 至此，一行显示完成

;本行的列循环结束
    pop bx                  ; 恢复行起始位置
    add bx, 160             ; 下一行
    pop cx                  ; 恢复行循环计数器
    inc di                  ; 下一个颜色属性
    xor si, si              ; 重置字符串偏移（回到开头）
    loop row                ; 行循环中包含了列循环！
;行循环结束

    mov ax, 4c00h 
    int 21h 

codesg ends
end start