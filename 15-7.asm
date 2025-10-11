.MODEL SMALL
.STACK 100H
.DATA
    ; HUAWEI 图案数据 - 每个字母7行高
    h_pattern DB 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0  ; H
              DB 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0
              DB 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0
              DB 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
              DB 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0
              DB 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0
              DB 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0

    u_pattern DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1  ; U
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0

    a_pattern DB 0,0,0,0,0,0,1,1,1,0,0,0,0,0,0  ; A
              DB 0,0,0,0,1,1,0,0,0,1,1,0,0,0,0
              DB 0,0,0,1,0,0,0,0,0,0,0,1,0,0,0
              DB 0,0,1,0,0,0,0,0,0,0,0,0,1,0,0
              DB 0,1,1,1,1,1,1,1,1,1,1,1,1,1,0
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1

    w_pattern DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1  ; W
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
              DB 1,0,0,0,0,0,1,0,1,0,0,0,0,0,1
              DB 1,0,0,0,1,0,0,0,0,0,1,0,0,0,1
              DB 0,1,0,1,0,0,0,0,0,0,0,1,0,1,0
              DB 0,0,1,0,0,0,0,0,0,0,0,0,1,0,0

    e_pattern DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  ; E
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              DB 1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

    i_pattern DB 1,1,1,1,1  ; I
              DB 0,0,1,0,0
              DB 0,0,1,0,0
              DB 0,0,1,0,0
              DB 0,0,1,0,0
              DB 0,0,1,0,0
              DB 1,1,1,1,1

    start_row DB 9
    start_col DB 0

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX
    
    ; 设置80x25文本模式
    MOV AX, 0003H
    INT 10H
    
    ; 隐藏光标
    MOV AH, 01H
    MOV CX, 2000H
    INT 10H
    
    ; 清屏为蓝色背景
    MOV AX, 0600H
    MOV BH, 17H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    
    ; 显示HUAWEI
    CALL DISPLAY_HUAWEI
    
    ; 等待按键
    MOV AH, 00H
    INT 16H
    
    ; 返回DOS
    MOV AX, 4C00H
    INT 21H

DISPLAY_HUAWEI PROC
    ; 显示H (0-14列)
    MOV SI, OFFSET h_pattern
    MOV start_col, 0
    CALL DISPLAY_LETTER
    
    ; 显示U (15-29列)
    MOV SI, OFFSET u_pattern
    MOV start_col, 15
    CALL DISPLAY_LETTER
    
    ; 显示A (30-44列)
    MOV SI, OFFSET a_pattern
    MOV start_col, 30
    CALL DISPLAY_LETTER
    
    ; 显示W (45-59列)
    MOV SI, OFFSET w_pattern
    MOV start_col, 45
    CALL DISPLAY_LETTER
    
    ; 显示E (60-74列)
    MOV SI, OFFSET e_pattern
    MOV start_col, 60
    CALL DISPLAY_LETTER
    
    ; 显示I (75-79列)
    MOV SI, OFFSET i_pattern
    MOV start_col, 75
    CALL DISPLAY_LETTER
    
    RET
DISPLAY_HUAWEI ENDP

; 显示单个字母
; 输入: SI=图案地址, start_col=起始列
DISPLAY_LETTER PROC
    MOV DH, start_row    ; 起始行
    MOV CX, 7            ; 7行
    
ROW_LOOP:
    PUSH CX
    PUSH SI
    
    ; 设置光标位置
    MOV AH, 02H
    MOV BH, 00H
    MOV DL, start_col    ; 起始列
    INT 10H
    
    ; 确定列数
    MOV CX, 15           ; 默认15列
    CMP start_col, 75    ; 如果是I字母
    JNE NOT_I
    MOV CX, 5            ; I只有5列
    
NOT_I:
    MOV BX, 0            ; 列计数器
    
COL_LOOP:
    ; 检查是否显示方块
    CMP BYTE PTR [SI+BX], 1
    JNE SHOW_SPACE
    
    ; 显示实心方块
    MOV AL, 219
    PUSH BX
    MOV BL, 0F0H         ; 黑底白字高亮
    JMP OUTPUT_CHAR
    
SHOW_SPACE:
    MOV AL, ' '
    PUSH BX
    MOV BL, 17H          ; 蓝底白字
    
OUTPUT_CHAR:
    PUSH CX
    
    ; 显示字符
    MOV AH, 09H
    MOV CX, 1
    INT 10H
    
    ; 移动光标到下一列
    MOV AH, 02H
    INC DL
    INT 10H
    
    POP CX
    POP BX
    
    INC BX
    LOOP COL_LOOP
    
    POP SI
    ; 移动到下一行数据
    CMP start_col, 75
    JNE NEXT_15
    ADD SI, 5            ; I字母：下一行前进5字节
    JMP NEXT_ROW
NEXT_15:
    ADD SI, 15           ; 其他字母：下一行前进15字节
    
NEXT_ROW:
    POP CX
    INC DH               ; 下一行
    LOOP ROW_LOOP
    
    RET
DISPLAY_LETTER ENDP

END START