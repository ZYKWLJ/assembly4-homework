assume cs:code,ds:data

data segment
    old_int9_offset dw 0
    old_int9_segment dw 0
    linux_str db 'Welcome to Linux!','$'
data ends

code segment

    start:
    mov ax,data
    mov ds,ax  
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
    mov di, 0   ; Center of screen (row 12, column 40)
    
    mov ah, 02h          ; Green color
    mov bx, 2000

                    ;ONLY  Print '.' for 2000 times 
print:
    cmp bx, 0
jle print
      
    dec bx
    call delay
    mov al, ' '
                    ;print 'Welcome to Linux!' in the middle of the srceen
    cmp di, 160*12+80-16    ; Center of screen (row 12, column 40)
    jl final
    cmp di, 160*12+80+16    ; Center of screen (row 12, column 40)
    jg final

    push si
    mov si, di
    sub si, 160*12+80-16    ; offset of Linux_str
    shr si, 1               ; every character is 2 bytes
    mov al, [linux_str+si]  ; read character from Linux_str
    pop si

final:
    mov byte ptr es:[di], al     ; Write character to video memory
    mov byte ptr es:[di+1], ah   ; Write color attribute
    add di, 2            ; Next video memory position
    jmp print    

;==============================================================================
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
    mov cx,0005h     ; Outer loop counter
delay_outer:
    mov ax,0001h     ; Inner loop counter
delay_inner:
    dec ax
    jnz delay_inner   ; Continue inner loop if ax is not 0
    loop delay_outer  ; Continue outer loop if cx is not 0

    pop cx
    pop ax
    ret

int9:
    push ax
    push es
                            ; Change color of current character


    in al, 60h           ; Read keyboard scan code
    
                        ; Call original int9 handler
    pushf
    call dword ptr [old_int9_offset]
    
    cmp al, 1            ; Check if Esc key pressed (scan code 1)
    jne int9_exit
    
Increment_color:
    mov ax, 0b800h
    mov es, ax
    mov si, 1
    mov cx, 2000                   ; 26Characters
color_loop:
    inc byte ptr es:[si]         ; modified the color
    add si, 2                    ; next one 
    loop color_loop              ; loop 26 times


int9_exit:
    pop es
    pop ax
    iret

code ends
end start  