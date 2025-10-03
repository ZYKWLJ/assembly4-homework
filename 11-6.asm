; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/zIqzs8bTznrADBujIdi_EQ   #    
; #                                                               #
; #################################################################

;编程，访问flags寄存器，保存在ax寄存器中
assume cs:codesg

codesg segment
start_:
     mov ax,3;
     cmp ax,1;
     pushf;将flags寄存器的值压栈
     pop ax;将flags的值保存在ax寄存器中

     mov ax, 4c00h 
     int 21h 
codesg ends
end start_