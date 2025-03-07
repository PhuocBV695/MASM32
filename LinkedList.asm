.386
.model flat, stdcall
.stack 4096
;option casemap :none
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
include irvine32.inc
includelib irvine32.lib 
;include \masm32\include\masm32rt.inc

include \masm32\include\msvcrt.inc
includelib \masm32\lib\msvcrt.lib


.data
    sym db '0123456789abcdef',0
    hConsoleIn dd ?  
    hConsoleOut dd ?
    S db 256 dup(0)
	chao db 'Chuyen doi co so bang danh sach lien ket',0dh, 0ah, 'nhap co so 10: ', 0
    chao_len equ $- chao
    chao_read dd 0
    chao2 db 'nhap base: ', 0
    chao2_len equ $- chao2
    chao2_read dd 0
	sai db 'khong hop le',0dh, 0ah, 0
    sai_len equ $- sai
    sai_read dd 0
    stack_top dd 0 ;  
    buf db 200, 0, 200 dup(0) 
    buf_read dd 0 
    n dd 0
    format db "%c",0
    dem dd 0

.code
start:
	invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hConsoleOut, eax 
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hConsoleIn, eax

    invoke WriteConsoleA, hConsoleOut, addr chao, chao_len, chao_read, 0
    invoke ReadConsoleA, hConsoleIn, addr buf, 198, addr buf_read, 0
    mov ecx, buf_read
    sub ecx, 2
    mov buf_read, ecx
    lea ebx, buf
    mov ecx, buf_read  
    push [buf_read]
    call stringtonum 
    ;call WriteDec
    ;mov [n], eax
    mov stack_top, 0
    ;mov eax, [n]
    invoke WriteConsoleA, hConsoleOut, addr chao2, chao2_len, chao2_read, 0
    call ReadDec
    cmp eax, 16
    jg not_legal
    cmp eax,2
    jb not_legal
    push eax
    ;push eax
    call convertbase2
    mov esi, [dem]
d:
    call pop_value
    dec esi
    cmp esi, 0
    jne d




    invoke ExitProcess, 0
not_legal:
    invoke WriteConsoleA, hConsoleOut, addr sai, sai_len, sai_read, 0
    invoke ExitProcess, 0


convertbase2 PROC bin
    ;LOCAL Q:DWORD
    LOCAL du:BYTE

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor esi, esi
tt:
    bignum:
        xor eax, eax
        mov al, [buf+esi]
        add al, du
        add al, du
        add al, du
        add al, du
        add al, du
        add al, du
        add al, du
        add al, du
        add al, du
        add al, du
        mov ebx, bin
        div bl
        mov [buf+esi],al
        mov du, ah
        inc esi
        cmp esi, [buf_read]
        jne bignum
        xor esi, esi
        xor eax, eax
        mov al, du
        xor ecx, ecx
        mov cl, 255
        pp2:
            inc cl
            cmp al, cl
            jne pp2
        xor ch, ch
        mov al, [sym+ecx]
        push eax
        call push_value
        mov [du], 0
        mov ebx, [dem]
        inc ebx
        mov [dem], ebx
        xor ebx, ebx
        
    kiemtra:

        mov al, [buf+ebx]
        inc ebx

        cmp al, 0
        je kiemtra
        cmp ebx, [buf_read]
        jng tt
        ret
    ttt: 
        ret

        

convertbase2 ENDP

creat PROC value: DWORD
    LOCAL nodept:DWORD
    push 8  ;4 dia chi, 4 value
    call crt_malloc ; malloc
    add esp, 4  ;
    mov nodept, eax; eax tro den vung bo nho da cap phat
    mov edx, value
    mov [eax], edx; node->data = value
    mov DWORD PTR [eax+4], 0; node->next = null
    mov nodept, eax
    ret
creat ENDP

push_value PROC value: DWORD
    LOCAL newnode:DWORD
    push value
    call creat
    mov newnode, eax; eax chua dia chi cua node
    mov edx, stack_top
    mov [eax+4], edx; [eax]= data; [eax+4]= address cua node tiep theo, truoc do da tam bo vao stack_top
    mov stack_top, eax ; bo dia chi cua node hien tai vao stack_top
    ret
push_value ENDP

pop_value PROC
    LOCAL temp:DWORD
    LOCAL value:DWORD
    mov eax, stack_top
    mov temp, eax; tam luu tru address cua node hien tai vao temp de co address ma free
    mov edx, [eax];
    mov value, edx; luu data cua node tren cung vao value
    mov edx, [eax+4];
    mov stack_top, edx; luu address cua node tiep theo vao stack_top
    push temp
    call crt_free
    add esp, 4
    mov eax, value
    invoke crt_printf,addr format, al
    ret
pop_value ENDP

dec_to_bin PROC
dec_to_bin ENDP

stringtonum PROC dia_read: DWORD
    xor eax, eax        
    xor esi, esi        
    
      
    
convert_loop:
    xor edx, edx       
    mov dl, byte ptr [ebx + esi]   
    
    cmp dl, '0'         
    jl not_digit
    cmp dl, '9'
    jg not_digit
    
    sub dl, '0'        
    
    mov [ebx+esi], dl       
    
    inc esi           
    cmp esi, dia_read        
    je done_convert  
    loop convert_loop   
not_digit:
    invoke WriteConsoleA, hConsoleOut, addr sai, sai_len, sai_read, 0
    invoke ExitProcess, 0
    
done_convert:           
    ret
stringtonum ENDP

end start
