; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;这个程序什么都不用做，仅仅验证12-0.asm中，data段和元数据段的区别，前者会被os覆盖，后者不会。
assume cs:codesg,ds:datasg

datasg segment
    db 'this is linux, I love you.',0;数据区,另一个进程启动时，不写入数据，查看数据段是不是这个一样的数据就行了。
datasg ends

codesg segment
start_:
    ;一般来说，开始的1KB是RAM区，即0000:0000-0000:03FF的1024个字节单元
    ;这个程序什么都不用做，仅仅验证12-0.asm中，data段和元数据段的区别，前者会被os覆盖，后者不会。
    mov ax, datasg
    mov ds, ax
end_:
     mov ax, 4c00h 
     int 21h 
codesg ends
end start_