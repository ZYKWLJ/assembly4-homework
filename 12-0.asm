; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;编写程序，验证内存元数据区不会被操作系统接管，所以数据在不同的进程中一致；而诸如data区会随着进程消亡被操作系统擦除。
assume cs:codesg,ds:datasg

datasg segment
    db 'this is data zone, and it will not be erased by os.',0;数据区,另一个进程启动时，不写入数据，查看数据段是不是这个一样的数据就行了。
datasg ends

codesg segment
start_:
    ;一般来说，开始的1KB是RAM区，即0000:0000-0000:03FF的1024个字节单元
    mov ax, datasg
    mov ds, ax
    mov ax, 0000h
    mov es, ax
    mov di, 0200h
    mov byte ptr es:[di], 11h;不同进程启动，未执行时，查看0000:0020处是不是这个值。如果是，则说明元数据区没有被操作系统接管，不同进程间共享数据。
end_:
     mov ax, 4c00h 
     int 21h 
codesg ends
end start_