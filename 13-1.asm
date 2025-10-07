; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;验证通过int指令来执行中断程序，具体——int 0除法中断程序执行
assume cs:codesg

codesg segment 

start_: 
    int 0;调用除法中断程序执行

codesg ends
end start_