; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/N36H4Ip20RjYfpqTFdn_hA   #    
; #                                                               #
; #################################################################

;验证ss和sp的操作是一体的，不可分割的，Debug不能在中间相应单步中断的。
assume cs:codesg

codesg segment 

start_: 
    ; 将栈段寄存器ss设置为0000h，栈指针sp设置为0000h，也就是将栈顶设置在0000:0000处。
    mov ax,0000h
    mov ss,ax
    mov sp,0000h
    
codesg ends
end start_