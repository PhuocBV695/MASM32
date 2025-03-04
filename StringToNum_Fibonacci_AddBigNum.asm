.386
.model flat, stdcall
.stack 4096
;option casemap :none
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
include irvine32.inc
includelib irvine32.lib  

.data
    chao db "Fibonacci quy hoach dong",0dh,0ah, 0
    chao_len equ $- chao
    nn db "so thu n: ",0
    nn_len equ $- nn
    sai db "khong hop le",0dh,0ah, 0
    sai_len equ $- sai
    buf db 20, 0, 20 dup(0) 
    buf_read dd 0  
    n dd 0      
    hConsoleIn dd ?  
    hConsoleOut dd ? 
    n1 db 120 dup(0) 
    n1_read dd 0  
    n2 db 1,119 dup(0) 
    n2_read dd 0
    sum db 120 dup(0) 
    sum_read dd 0
    nho db 120 dup(0)
    dem db 0
    thuong db 0
    array1 db 0
    array2 db 0
    ji dd 0
    chuoi db 120 dup(0)
    chuoi_read dd 0
.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hConsoleOut, eax 
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hConsoleIn, eax
    
    invoke WriteConsoleA, hConsoleOut, addr chao, chao_len, addr buf_read, 0
    
    invoke WriteConsoleA, hConsoleOut, addr nn, nn_len, addr buf_read, 0
    
    invoke ReadConsoleA, hConsoleIn, addr buf+2, 18, addr buf_read, 0
    
    mov ecx, buf_read
    sub ecx, 2
    mov buf_read, ecx
    
    lea ebx, buf+2
    mov ecx, buf_read   
    
    call stringtonum   
    mov [n], eax          
    
    mov eax, [n]
    ;call WriteDec
    call fibo
    call reversestring
    invoke WriteConsoleA, hConsoleOut, addr chuoi, 120, addr chuoi_read, 0
   
    invoke ExitProcess, 0

stringtonum PROC
    push ebx            
    push ecx            
    push edx            
    push esi            
    
    xor eax, eax        
    xor esi, esi        
    
    cmp ecx, 0          
    jle done_convert    
    
convert_loop:
    xor edx, edx       
    mov dl, byte ptr [ebx + esi]   
    
    cmp dl, '0'         
    jl not_digit
    cmp dl, '9'
    jg not_digit
    
    sub dl, '0'        
    
    push edx            
    mov edx, 10
    mul edx             
    pop edx             
    add eax, edx        
    
not_digit:
    inc esi             
    loop convert_loop   
    
done_convert:
    pop esi             
    pop edx             
    pop ecx             
    pop ebx             
    ret
stringtonum ENDP

fibo PROC
    cmp     [n], 0
    jbe     l1
    cmp     [n], 1
    je      l2
    cmp     [n], 2
    je      l3
    sub     [n], 2
    mov ecx, [n]
    xor eax, eax
    xor esi, esi
    jmp loo
loo:
    
    call r
    ;h
 
    call CopyArray

    call CopyArray2
    ;jmp swap1
    inc esi
    cmp esi,[n]
    jb loo
    call cong
    ret
    
    

;swap1:
cong PROC
    mov ecx, 120
    xor esi, esi
k:
    mov al, [sum+esi]
    add al,'0'
    mov [sum+esi], al
    inc esi
    loopnz k
    ret
cong endp
r PROC
    mov ecx, 120
    xor eax, eax
    xor edx, edx
    jmp u
u:
    xor ebx, ebx
    xor eax, eax
    mov bl, [n1+edx]
    mov al, [n2+edx]
    mov [ji], edx
    xor edx, edx
    add bl, al
    add bl, [thuong]
    mov [dem], bl
    mov al, [dem]
    mov bl,10
    ;mov ebx, [dem]
    div bl
    ;add dl, '0'
    ;cmp dl, 1
    xor edx, edx
    
    mov [thuong], al
    mov edx, [ji]
    mov [sum+edx], ah
    inc edx
    loopnz u
    ret
r ENDP
CopyArray PROC
    mov ecx, 120           
    xor ebx, ebx              
    xor edx, edx            
copy_loop:
    mov al, [n2+ebx]                   
    mov [n1+ebx], al                   
    inc ebx                          
    loopnz copy_loop                   
    ret
CopyArray ENDP
CopyArray2 PROC
    mov ecx, 120           
    xor ebx, ebx              
    xor edx, edx            
copy_loop:
    mov al, [sum+ebx]                   
    mov [n2+ebx], al                   
    inc ebx                          
    loopnz copy_loop                   
    ret
CopyArray2 ENDP
    
l1:
    push    0               
    push    offset sai_len  
    push    offset sai 
    push    hConsoleOut             
    call    WriteConsoleA
    push    0               
    call    ExitProcess 
l2:
    ret
l3:
    ret
fibo ENDP
reversestring PROC
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor esi, esi
    
    ;mov ecx, 120
t:
    inc esi
    mov eax, 120
    sub eax, esi
    cmp [sum+eax], '0'
    je t
    jmp tt
tt:
    mov eax, 120
    sub eax, esi
    inc esi
    mov dl, [sum+eax]
    mov [chuoi+ebx], dl
    inc ebx
    cmp esi,120
    jbe tt
    ret


reversestring ENDP
end start
