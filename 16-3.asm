;   体会`a：`和`a`的区别
;   本节讲述 `a`，也就是数据地址的标签，仅仅表示一个地址，对后面的数据长度做确保
assume cs:code 

code segment
  
str db 'a','b','c';这后面的数据全是字节

start:
    mov ah, 9
    mov si, 0
    mov al, str[si]
    mov bl, 11001010b
    mov bh, 0
    mov cx, 1
    int 10h 

    mov ax, 4c00h
    int 21h
  
code ends
end start  