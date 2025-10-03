; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/zIqzs8bTznrADBujIdi_EQ   #    
; #                                                               #
; #################################################################

;编程，测试flag寄存器的变化,由于df位测试较为复杂，后续单独出程序测试

assume cs:codesg

codesg segment
start_:
    mov ax,0;测试zf位、sf位、cf位、of位
    mov ax,0fffeh
    add ax,0002h ;测试of位，此时为of=1
    sub ax,0002h ;测试sf位，此时为sf=1
end_: 
    mov ax, 4c00h 
    int 21h 
codesg ends
end start_