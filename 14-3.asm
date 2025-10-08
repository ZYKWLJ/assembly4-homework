assume cs:code
code segment
start: 
    mov al,8
    out 70h,al
    in al,71h

    mov ah,al
    mov cl,4
    shr ah,cl
    and al,00001111b

    add ah,30h
    add al,30h

    mov bx,0b800h
    mov es,bx
    mov byte ptr es:[160*12+40*2],ah      ; 显示月份的十位数码
    mov byte ptr es:[160*12+40*2+1],11000010b ;红底绿字属性：11000010b
    mov byte ptr es:[160*12+40*2+2],al      ; 显示月份的十位数码
    mov byte ptr es:[160*12+40*2+3],11000010b ;红底绿字属性：11000010b

    mov ax,4c00h
    int 21h
code ends
end start