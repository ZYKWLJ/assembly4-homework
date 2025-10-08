; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

; (1) 编程，读取`CMOS RAM`的2号单元的内容。
  
; (2) 编程，向`CMOS RAM`的2号单元写入0。

assume cs:code 
 
code segment

start:
    ; (1) 读取CMOS RAM的2号单元的内容
    mov al, 2        ; 要访问的CMOS单元号
    out 70h, al      ; 向地址端口70h写入单元号
    in al, 71h       ; 从数据端口71h读取数据到al
    
    ; 此时al中就是2号单元的内容
    ; 可以在这里保存或处理读取的值
    
    ; (2) 向CMOS RAM的2号单元写入0h
    mov al, 2        ; 要访问的CMOS单元号  
    out 70h, al      ; 向地址端口70h写入单元号,表示我们要访问2号单元
    mov al, 0        ; 要写入的数据
    out 71h, al      ; 向数据端口71h写入数据0h

    ; (3) 可选：读取验证
    mov al, 2
    out 70h, al
    in al, 71h       ; 从数据端口71h读取数据到al，看看是不是0

    mov ax, 4c00h
    int 21h 
code ends
end start