; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;验证除法错误中断处理程序。
assume cs:codesg 

codesg segment 

start_: 
    安装好do0中断处理程序
    设置好中断向量表, 将do0中断处理程序的入口地址写入0000:0000-0000:0003

end_:
     mov ax, 4c00h 
     int 21h 

do0:
    显示字符串"overflow!";中断处理程序
    mov ax,4c00h 
    int 21h

codesg ends
end start_