; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

 
;使用中断int指令(不依赖loop)，编写一个普通程序，在屏幕中间打印80个绿色感叹号
;这是使用了dec、jnz指令的程序框架
assume cs:code

code segment
; 主程序部分
start:

setup_7c:
    ; 安装中断程序覆写到0000:007ch,
    mov ax, cs
    mov ds, ax
    mov si, offset interrupt_7c;源地址
    mov ax, 0000h
    mov es, ax
    mov di, 0200h;目的地址
    mov cx, offset end_interrupt_7c - offset interrupt_7c
    cld
    rep movsb
  
    ; 中断地址表装载中断程序双地址。
    mov ax, 0000h
    mov ds, ax
    mov di, 007ch*4 ;一个表项占4字节，所以*4 
    ; 高字存段地址，低字存偏移地址。
    mov word ptr [di], 0200h;
    mov word ptr [di+2], 0000;

    ; 调用中断程序
    int 7ch

end_:
    mov ax, 4c00h; 程序退出，调用 21h 中断的 4C00h 功能号
    int 21h    

interrupt_7c:
    ;中断程序的具体操作，主要是进行地址跳转以及满足cx后的操作
    ; 地址跳转
    ;显存设置
    mov ax, 0b800h; 设置 es 为显存段地址（B800h 是文本模式显存起始地址）
    mov es, ax
    mov di, 160 * 12; di = 160 * 12，计算第 12 行的起始偏移（每行 160 字节）
    mov cx, 80; cx = 80，控制循环次数（写入 80 个 '!'）
 
s:
    mov byte ptr es:[di], '!'; 向显存 es:[di] 写入字符 '!'（字节操作）
    mov byte ptr es:[di+1], 02h; 向显存 es:[di] 写入字符属性，绿色
    add di, 2; di += 2，指向下一个字符位置（显存中每个字符占 2 字节，低字节是字符，高字节是属性）
    ;调用中断，中断调用后，再返回s标签，一共中断cx次
    dec cx
    jnz s
    iret

end_interrupt_7c:;中断程序大小截止标签
    nop
  
code ends
end start 