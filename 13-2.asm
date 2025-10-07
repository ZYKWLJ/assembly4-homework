; #################################################################
; #                                                               #
; #  公粽号「专注Linux」，专注Linux内核开发.                         #
; #  本文链接：https://mp.weixin.qq.com/s/CtzjVzj5WpTG8m4nULwNWw   #    
; #                                                               #
; #################################################################

;编写一个普通程序，在屏幕中间打印80个绿色感叹号
assume cs:code

code segment
; 主程序部分
start:
    ;显存设置
    mov ax, 0b800h; 设置 es 为显存段地址（B800h 是文本模式显存起始地址）
    mov es, ax
    mov di, 160 * 12; di = 160 * 12，计算第 12 行的起始偏移（每行 160 字节）
    mov cx, 80; cx = 80，控制循环次数（写入 80 个 '!'）

    ;
s:
    mov byte ptr es:[di], '!'; 向显存 es:[di] 写入字符 '!'（字节操作）
    mov byte ptr es:[di+1], 02h; 向显存 es:[di] 写入字符属性，绿色
    add di, 2; di += 2，指向下一个字符位置（显存中每个字符占 2 字节，低字节是字符，高字节是属性）
    loop s

end_:
    mov ax, 4c00h; 程序退出，调用 21h 中断的 4C00h 功能号
    int 21h

code ends
end start; 程序从 start 开始执行