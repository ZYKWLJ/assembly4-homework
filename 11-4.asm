; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/zIqzs8bTznrADBujIdi_EQ   #    
; #                                                               #
; #################################################################

;编程，测试adc、sbb指令
assume cs:codesg

codesg segment
start_:
     mov ax,0ffffh
     add ax,1h;产生进位
     adc ax,0h;查看ax的值是否为1，bx为1，说明有进位
     sub ax,2h;产生借位,ax为0ffffh
     sbb ax,0h;查看ax的值是否为fffeh，ax为fffeh，说明有借位

end_: 
    mov ax, 4c00h 
    int 21h 
codesg ends
end start_