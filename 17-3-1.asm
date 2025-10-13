getstr:
	push ax

getstrs:
	mov ah,0
	int 16h			;使用int 16读取键盘缓冲区的数据，该功能的编号为 0
		
	cmp al 20h		;这里说明不是字符，这个值是32,对应的
	jb nochar		;不是字符，查看是不是删除或者enter
	mov ah, 0		;是字符，先入栈
	call charstack		;调用0号功能，字符入栈
	mov ah, 2		;再显示
	call charstack 	;调用2号功能，显示栈中的字符
	jmp getstrs		;继续循环等待输入

nochar:
	cmp ah, 0eh
	je backspace
	cmp ah, 1ch
	je enter
	jmp getstrs
	
backspace:
	mov ah, 1
	call charstack	;字符出栈
	mov ah, 2
	call charstack 	;显示栈中的字符(因为不管入栈出栈，都要显示字符！)
	jmp getstrs	;继续读取
	
enter:			;输入结束，开启下一段输出，继续显示prompt
	mov al, 0
	mov ah, 0
	call charstack	;0入栈
	mov ah, 2
	call charstack 	;显示栈中的字符
	pop ax
	ret



