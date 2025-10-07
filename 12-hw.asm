; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/N36H4Ip20RjYfpqTFdn_hA   #    
; #                                                               #
; #################################################################

;安装并验证除法错误中断处理程序。
assume cs:codesg

codesg segment 

start_: 
    ;安装好do0中断处理程序
     mov ax,cs
     mov ds,ax
     mov si,offset do0
     mov ax,0000h ;这里是常驻中断处理程序的内存起始地址
     mov es,ax
     mov di,0200h
     mov cx,offset do0end - offset do0
     cld ;设置movsb指令为正向复制，从ds:si复制到es:di
     rep movsb; 完成do0中断处理程序的安装(所谓安装，也就是复制do0程序到0200:0000的过程)

    ;设置好中断向量表, 将do0中断处理程序的入口地址写入0000:0000-0000:0003
     mov ax,0000h
     mov ds,ax
     mov di,0000h
     mov word ptr [di],0200h ;低字节存放偏移地址 
     mov word ptr [di+2],0000h ;高字节存放段地址

     ; 添加测试代码触发除法错误
     mov ax, 1000h
     mov bl, 0
     div bl

end_:
     mov ax, 4c00h 
     int 21h 

do0:
    jmp short do0_start ; 添加跳转指令跳过数据区
    db  "[Linux error]: Divide overflow!",0;这个数据也是常驻内存的，必须安装在这里(后被移植到ROM中)

do0_start:
    ;中断处理程序, 显示字符串"overflow!"
    mov ax, 0000h;数据已经被移植到0000:0200h了
    mov ds, ax
    mov si, 0200h + 2 ; 跳过jmp指令，指向字符串数据,注意此时数据已经复制到0000:0202h了
    mov ax, 0b800h;显存地址
    mov es, ax
    mov di, 160*12+32*2;显存偏移地址

iter_str:
    ;显存是0xb8000-0xbffff，每个字符占用2个字节，低存放字符，高存放属性。
    cmp byte ptr [si], 0
    je end_trap
    mov al,[si]
    mov byte ptr es:[di],al
    mov byte ptr es:[di+1],02h
    add di,2
    inc si
    jmp near ptr iter_str
    

end_trap:
    ;显示完了，就返回dosbox
    mov ax, 4c00h 
    int 21h
    ;注意，出现除法错误，会导致程序异常终止，所以这里要返回dosbox，而不是在ret啥的了！
    ;iret

do0end:
    nop ;这里占用一个字节，是为了和do0的长度对齐，nop无实际意义。
    

codesg ends
end start_