; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

 
;使用中断int指令和堆栈原理(不依赖loop)，编写一个普通程序，在屏幕中间打印80个绿色感叹号
;本质——篡改中断母程序程序入栈的IP

assume cs:code

code segment
start:
    ; 安装中断处理程序
    mov ax, cs
    mov ds, ax
    mov si, offset interrupt_7c
    
    mov ax, 0
    mov es, ax
    mov di, 7ch * 4
    cli ;清除中断标志位（IF）,并屏蔽中断
    mov ax, offset interrupt_7c
    mov es:[di], ax
    mov ax, cs
    mov es:[di+2], ax
    sti ;设置中断标志位（IF）,允许中断
    
    ; 主程序开始
    mov ax, 0b800h
    mov es, ax
    mov di, 160*12; 屏幕第12行 

    ;这里使用栈的思想，给出了loop重复单元的转移位移,这里bx是负数
    mov bx, offset s - offset se    ; 设置从标号se到标号s的转移位移
    mov cx, 80                     ; 循环次数
    
s: 
    mov byte ptr es:[di], '!'      ; 显示感叹号
    mov byte ptr es:[di+1], 2      ; 设置颜色属性（绿色）
    add di, 2
    int 7ch                        ; 调用自定义中断
    
se:
    nop

    ; 程序结束
    mov ax, 4c00h
    int 21h

; 7ch 中断处理程序
interrupt_7c:
    push bp;这里push只是为了保证栈帧的平衡，是基本模板,可以去掉，但最好加上
    mov bp, sp
    
    dec cx
    jcxz end_interrupt_7c
    add [bp+2], bx    ; 修改返回地址为，实现跳转，
    ;add [bp], bx    ; 修改返回地址为，实现跳转，
end_interrupt_7c:
    ;pop bp
    iret

code ends
end start