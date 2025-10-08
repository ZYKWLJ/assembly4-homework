; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;使用BIOS的10号中断例程，在屏幕指定位置显示80个红底高亮闪烁绿色的“a”
assume cs:code
code segment
    ;这里可以选择是否置光标，不置，就是默认下滚。
    mov ah,2           ;置光标
    mov bh,0           ;第0页
    mov dh,12           ;dh 中放行号
    mov dl,0          ;dl 中放列号
    int 10h

    mov ah,9           ;在光标位置显示字符
    mov al,'a'         ;字符
    mov bl,11001010b   ;颜色属性
    mov bh,0           ;第0页
    mov cx,80          ;字符重复个数
    int 10h

    mov ax,4c00h
    int 21h
code ends
end