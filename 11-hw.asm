; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;编写一个子程序，将包含任意字符，以0结尾的字符串中的小写字母转变成大写字母。
assume cs:codesg,ds:datasg

datasg segment
    db '@@Hello, welcome to my world! Enjoy the Linux!@@',0
datasg ends

codesg segment
start_:
     ;需要分析大于等于a，小于等于z，判断，在进行转换，否则不变.
     mov ax,datasg ;注意，这里一定要将数据段的地址加载到ds寄存器中，因为ds段寄存器一开始在关联的数据段的前面16个字节处。这16个字节存储的是元数据，不是在数据段的起始地址处。
     mov ds,ax
     mov si,0

iter_str:
     mov al,[si];记住，这里比较的是单个字节，所以要大小匹配，使用的是al
     cmp al, 0
     je end_
     cmp al, 'a'
     jl copy_char
     cmp al, 'z'
     jg copy_char
     and al,11011111b;这里一定会转化为大写字符

copy_char:
     mov [si],al
     inc si
     jmp iter_str

end_:
     mov ax, 4c00h 
     int 21h 
codesg ends
end start_