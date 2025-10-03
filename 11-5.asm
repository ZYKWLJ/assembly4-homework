; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/zIqzs8bTznrADBujIdi_EQ   #    
; #                                                               #
; #################################################################

;编程，如果ax大于1，则置bx为10，等于1，置为20，小于1，置为30
assume cs:codesg

codesg segment
start_:
     mov ax,3;
     cmp ax,1;
     jg greater_than_1;
     je equal_to_1;
     jl less_than_1;

greater_than_1:
     mov bx,10;
     jmp end_;

equal_to_1:
     mov bx,20;
     jmp end_;

less_than_1:
     mov bx,30;
     jmp end_;

end_: 
    mov ax, 4c00h 
    int 21h 
codesg ends
end start_