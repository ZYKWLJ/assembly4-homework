; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;验证编译器的offset指令实现计算代码段长度的功能
assume cs:codesg 

codesg segment 

start_: 
     mov ax, offset do0end - offset do0;编译器利用offset伪指令，自动计算do0中断处理程序的长度

end_:
     mov ax, 4c00h 
     int 21h 

do0:
    mov ax,4c00h 
    int 21h

do0end:nop
codesg ends
end start_