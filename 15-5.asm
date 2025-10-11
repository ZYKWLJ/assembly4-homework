;满屏旋转字符实现
assume cs:code,ds:data

data segment
    old_int9_offset dw 0
    old_int9_segment dw 0
    one db '\','/','-'
data ends

code segment
    start:
    mov ax, data
    mov ds, ax
                                ; Save original int9 interrupt vector
    mov ax, 0
    mov es, ax
    mov ax, es:[9*4]
    mov [old_int9_offset], ax
    mov ax, es:[9*4+2]
    mov [old_int9_segment], ax
    
                                ; Set up new int9 interrupt handler
    cli
    mov word ptr es:[9*4], offset int9
    mov es:[9*4+2], cs
    sti
                            ; Display characters from 'a' to 'z'
    mov ax, 0B800h
    mov es, ax
    mov di, 0               ; Center of screen (row 12, column 40)
    mov ah, 02h             ; Green color

si_to_zero:
    mov si, 0
print:
    mov al, one[si]
    mov di, 0
all_screen:
                                 ; Center of screen (row 12, column 40)
    mov byte ptr es:[di], al     ; Write character to video memory
    mov byte ptr es:[di+1], ah   ; Write color attribute
    add di, 2
    cmp di, 4000
    jl all_screen

    call delay
    
    inc si            ; Next video memory position
    cmp si,2 
    jl print
    je si_to_zero
                        ; Restore original interrupt vector
    mov ax, 0
    mov es, ax
    cli
    mov ax, [old_int9_offset]
    mov es:[9*4], ax
    mov ax, [old_int9_segment]
    mov es:[9*4+2], ax
    sti

    mov ax, 4c00h        ; Exit to DOS
    int 21h

delay:                ;super classic delay program
    push ax
    push cx
    mov cx,0FFFFh     ; Outer loop counter
delay_outer:
    mov ax,00005h     ; Inner loop counter
delay_inner:
    dec ax
    jnz delay_inner   ; Continue inner loop if ax is not 0
    loop delay_outer  ; Continue outer loop if cx is not 0
    
    pop cx
    pop ax
    ret

int9:
    push si
    push ax
    push es
    
    in al, 60h           ; Read keyboard scan code
    
                        ; Call original int9 handler
    pushf
    call dword ptr [old_int9_offset]
    
    cmp al, 1            ; Check if Esc key pressed (scan code 1)
    jne int9_exit
    
                        ; Change color of current character
Increment_color:
    
    mov ax, 0b800h
    mov es, ax
    mov si, 0
    mov cx, 2000                   ; 26Characters
color_loop:
    inc byte ptr es:[si]         ; modified the color
    add si, 2                    ; next one 
    loop color_loop              ; loop 26 times

int9_exit:
    pop es
    pop ax
    pop si
    iret
  
code ends
end start 