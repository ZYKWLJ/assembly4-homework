; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/bcSHDcmVTru43nXcUGrWog   #    
; #                                                               #
; #################################################################
;编程:1.显示字符串的行列、颜色、内容
;名称：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串参数：
;(dh)=行号(取值范围0~24)，
;(dl)=列号（取值范围0~79)，
;(cl)=颜色，
;ds:si指向字符串的首地址
;返回：无

;分析
;因为是子程序，参数需要母程序传递，这里就假定在第10行，第10列，显示子串'welcome to linux!'
;提供参数：
;dh=行号
;dl=列号
;cl=颜色
;ds:si=字符串首地址

assume cs:codesg, ds:datasg

datasg segment 
    db 'welcome to linux!',0    ; 字符串数据
    db 02h                      ; 绿色字（无背景）
    db 41h                      ; 绿底红字  
    db 14h                      ; 白底蓝字
datasg ends 

codesg segment
start:
    mov ax, datasg
    mov ds, ax              ; ds指向数据段
    
    ; 设置参数
    mov dh, 10              ; 行号
    mov dl, 10              ; 列号
    mov cl, 02h             ; 颜色（使用绿色）
    mov si, 0               ; 字符串首地址
    
    call show_str           ;子程序调用结束后就返回主程序退出了
    
    mov ax, 4c00h 
    int 21h 

show_str:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    
    ; 设置显存段地址
    mov ax, 0B800h
    mov es, ax
    
    ; 计算显存偏移地址：行号*160 + 列号*2
    mov al, 160
    mul dh                  ; ax = 行号 * 160
    mov di, ax              ; di = 行偏移
    mov al, 2
    mul dl                  ; ax = 列号 * 2
    add di, ax              ; di = 最终显存偏移地址
    
    ; 保存颜色到bl
    mov bl, cl
    
show_loop:
    mov cl, [si]            ; 读取字符
    mov ch, 0               ; 高位清零
    jcxz show_end           ; 如果为0则结束
    
    mov es:[di], cl         ; 写入字符
    mov es:[di+1], bl       ; 写入颜色属性
    
    inc si                  ; 下一个字符
    add di, 2               ; 下一个显存位置
    jmp show_loop

show_end:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

codesg ends
end start