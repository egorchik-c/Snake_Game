section .data
 field db "#######################", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#                     #", 0xa
  db "#######################", 0xa
 field_len equ $ - field
 
 snake_x db 12
 snake_y db 6
 LEN db 24
 
section .text
 global _start
 
_start:
 movzx eax, byte [snake_y]
 movzx ebx, byte [LEN]
 mul ebx
 movzx edi, byte [snake_x]
 add eax, edi
 
 lea esi, byte [field]
 add esi, eax
 mov byte [esi], "O" 

 mov eax, 4
 mov ebx, 1
 mov ecx, field
 mov edx, field_len
 int 0x80
 
 mov eax, 1
 xor ebx, ebx
 int 0x80
