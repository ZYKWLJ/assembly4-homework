; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;编写一个普通程序，在屏幕中间打印80个绿色感叹号
;这是整体程序框架
assume cs:code

code segment
; 主程序部分
start:
    setup_7c:
    安装中断程序到0000:007ch,
    
    ;调用中断程序
    int 7ch 

    ;退出程序，返回dosbox
    mov ax, 4c00h; 程序退出，调用 21h 中断的 4C00h 功能号
    int 21h
  
interrupt_7c:
    中断程序的具体操作，主要是进行地址跳转以及满足cx后的退出操作
  
end_interrupt_7c:;中断程序大小截止标签
    nop
  
end_:
    mov ax, 4c00h; 程序退出，调用 21h 中断的 4C00h 功能号
    int 21h

code ends
end start 