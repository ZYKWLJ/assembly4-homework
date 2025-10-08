; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;使用DOS的21号中断例程的9号功能号，在屏幕上显示字符串“Welcome to linux!”
assume cs:code,ds:data
data segment
    db 'Welcome to linux!', '$'
data ends
code segment

start:
    ;这里可以选择是否置光标，不置，就是默认下滚。
    ; mov ah,2           ;置光标
    ; mov bh,0           ;第0页
    ; mov dh,12           ;dh 中放行号
    ; mov dl,0          ;dl 中放列号
    ; int 10h

    mov ax,data           ;在光标位置显示字符
    mov ds,ax             ;字符
    mov dx, 0             ;在光标处，显示的字符的原地址是：ds:dx
    mov ah,9              ;设置中断功能号为9，作用为在光标处显示字符 
    int 21h               ;调用中断例程号

    mov ax,4c00h
    int 21h
code ends
end start
 