.386
.model flat, stdcall
.stack 4096
;option casemap :none
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
include irvine32.inc
includelib irvine32.lib 
;include \masm32\include\masm32rt.inc

.data
    hConsoleIn dd ?  
    hConsoleOut dd ?
    S db 256 dup(0)
	chao db 'RC4 encryption',0dh, 0ah, 'nhap input: ', 0
    chao_len equ $- chao
    chao_read dd 0

    chao2 db 0dh, 0ah, 'nhap key: ', 0
    chao2_len equ $- chao2
    chao2_read dd 0

    buf db 256 dup(0) 
    buf_read db 0

    key db 256 dup(0)
    key_read db 0
    l db 0
    outt db 256 dup(0)
    sym db '0123456789abcdef',0
    outtt db 512 dup (0)
    outtt_read dd 0
    
.code
start:
	invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hConsoleOut, eax 
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hConsoleIn, eax



    invoke WriteConsoleA, hConsoleOut, addr chao, chao_len, chao_read, 0

    invoke ReadConsoleA, hConsoleIn, addr buf, 256, addr buf_read, 0
    ;invoke WriteConsoleA, hConsoleOut, addr buf, 256, addr buf_read, 0

    invoke WriteConsoleA, hConsoleOut, addr chao2, chao2_len, addr chao2_read, 0
    invoke ReadConsoleA, hConsoleIn, addr key, 256, addr key_read, 0
    ;invoke WriteConsoleA, hConsoleOut, addr key+2, 254, addr key_read, 0
    mov al, key_read
    ;call WriteDec
    call inn
    call ksa
    call PRGA
    call tohex
    ;mov al, [sym+1]
    ;call WriteDec
    invoke WriteConsoleA, hConsoleOut, addr outtt, 512, addr outtt_read, 0
    ;call ksa

    invoke ExitProcess, 0

PRGA PROC
    xor eax, eax
    mov al,[buf_read]
    sub al,2
    ;call WriteDec
    mov [buf_read], al
    mov [buf+eax], 0
    inc eax
    mov [buf+eax],0
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor esi, esi
e: 
    xor al,al
    inc cl
    add bl, [S+ecx]
    xor bh, bh
    mov dl, [S+ebx];bl==j
    mov al, [S+ecx];cl==i
    mov [S+ebx], al
    mov [S+ecx], dl
    add al, dl
    xor ah, ah
    mov al, [S+eax]
    xor al, [buf+esi]
    mov [outt+esi], al
    inc esi
    mov al, [buf_read]
    cmp esi, eax
    jne e
    ret
    

PRGA ENDP

tohex PROC
    xor esi, esi
    xor edx, edx

pp: 
    xor eax, eax
    xor ebx, ebx
    mov al, [outt+edx]
    mov bl, 16
    div bl
    xor ecx, ecx
    ;call WriteDec
    mov cl, 255
    pp1:
        inc cl
        cmp al, cl
        jne pp1
    xor ch, ch
    mov al, [sym+ecx]
    mov [outtt+esi],  al
    inc esi
    xor ecx, ecx
    mov cl, 255
    pp2:
        inc cl
        cmp ah, cl
        jne pp2
    xor ch, ch
    mov al, [sym+ecx]
    mov [outtt+esi], al
    inc esi
    inc edx
    xor eax, eax
    mov al, [buf_read]
    cmp edx, eax
    jb pp
    ret
tohex ENDP

ksa PROC
    xor eax, eax
    mov al,[key_read]
    sub al,2
    ;call WriteDec
    mov [key_read], al
    mov [key+eax], 0
    inc eax
    mov [key+eax],0
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor esi, esi
    mov al, 0
    mov cl,0
    jmp t
t:
    mov al, cl
    mov dl, [key_read]
    div dl
    mov [l], ah
    mov dl, [l]
    ;mov cl, dl
   ; xor al,al
    mov dl, [key+edx]
    mov al, [S+ecx]
    add bl ,dl
    add bl, al
   ; mov al, [bl]
    ;add bl, al
    xor bh,bh
    mov dl, [S+ebx];bl==j
    mov al, [S+ecx];cl==i
    mov [S+ebx], al
    mov [S+ecx], dl

    inc cl
    ;mov ecx,cl
    cmp cl,0
    jne t
    ret
    


ksa ENDP

inn PROC
    xor eax, eax
po:
    mov [S+eax], al
    inc eax
    cmp eax, 256
    jb po
    ret

inn ENDP

end start
