; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/N36H4Ip20RjYfpqTFdn_hA   #    
; #                                                               #
; #################################################################

;验证除法错误中断处理程序。
assume cs:codesg 

codesg segment 
start_: 
    mov ax,1000h
    mov bh,1;因为这里是8位的，所以商放在al中，余数放在ah中，但是8位的al只能表示最多FF，商的结果却是1000h，严重超出，会产生除法错误中断
    div bh

end_:
     mov ax, 4c00h 
     int 21h 
codesg ends
end start_