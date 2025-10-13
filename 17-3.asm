;字符栈子程序实现
;程序:字符栈的入栈、出栈和显示。
;参数说明:

;(ah)=功能号，0表示入栈，1表示出栈，2表示显示:ds:si指向字符栈空间;
;对于0号功能:(al)=入栈字符；
;对于1号功能:(al)=返回的字符；
;对于2号功能:显示字符串，其中(dh)=行、(dl)=列

charstack: 
	jmp short charstart		;这是子程序 ` 标准写法 `，在数据定义前面写一条跳转指令，实现数据定义与首指令跳转和执行！

table 	dw charpush, charpop, charshow	
						;对应的入栈、出栈、显示

top 		dw 0                    	;栈顶指针

charstart: 
	push bx				;子程序标准用法，保存自己会用到的寄存器
	push dx
	push di
	push es
	push ax

	cmp ah, 2                 ; 判断功能号是否大于2
	ja sret                     	; 若大于2则直接返回

	mov bl, ah			;ah存放的是功能号，注意一定是要bl，因为bx是基址寄存器，可以直接写在[]里面的，即[bx]。【ax:累加器、bx基址寄存器、cx计数寄存器、dx数据寄存器】
	mov bh, 0
	add bx, bx                 	; 计算功能号对应的偏移量，因为定址表是字大小，而我们的地址是字节。
	jmp word ptr table[bx]      ; 跳转到对应功能的子程序。这里使用了直接定制表的思想。

; 入栈子程序
charpush: 
	mov bx, top			；栈顶指针
	mov [si][bx], al            	; 将al中的字符存入栈中
	inc top                     		; 栈顶指针加1
	jmp sret

; 出栈子程序
charpop: 
	cmp top, 0        	 ; 判断栈是否为空
	je sret                     	 ; 栈空则返回
	dec top                     ; 栈顶指针减1
	mov bx, top
	mov al, [si][bx]           ; 将栈顶字符存入al中
	jmp sret

; 显示子程序
charshow: 
	mov bx, 0b800h    	; 显存段地址
	mov es, bx
	mov al, 160
	mov dh, 0
	mul dh                      ; 计算行偏移(每行160字节)，这里得到行显示的字节，ax里面是这个值
	mov di, ax			;这是何故？将ax里面的行偏移字节转存到di中
	add dl, dl			;这是列偏移，要加两次，因为每列两字节
	mov dh, 0			;这里又是干嘛呢？
	add di, dx			;加上了列偏移，现在di中存的就是字节显示的屏幕的位置的全部的字节偏移了 

	mov bx, 0

charshowes: 
	cmp bx, top     			; 判断是否显示完所有字符
	jne noempty			;还有字符，就显示！
	mov byte ptr es:[di], ' '   	; 栈空则显示空格
	jmp sret

noempty: 					;字符显示代码
	mov al, [si][bx]   		; 取出字符
	mov es:[di], al             	; 显示字符
	mov byte ptr es:[di+2], ' ' ; 清除下一个位置的残留字符
	inc bx
	add di, 2                   	; 移动到下一个显示位置
	jmp charshowes

sret: 
	pop es                		; 恢复寄存器
	pop di
	pop dx
	pop bx
	ret