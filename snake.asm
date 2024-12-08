section .data
	field db "#########################################", 0xa
	field_space db "#                                       #", 0xa

	snake_head db "O"
	snake_x db 12
	snake_y db 6
	LEN db 25
 
section .text
	global _start
 
_start:
 	mov eax, 4
 	mov ebx, 1
 	mov ecx, field
 	mov edx, 42
 	int 0x80
	
	mov esi, 17
	
field_body_draw:
	mov eax, 4
	mov ebx, 1
	mov ecx, field_space
	mov edx, 42
	int 0x80
	dec esi
	cmp esi, 0
	jnz field_body_draw
	
	mov eax, 4
	mov ebx, 1
	mov ecx, field
	mov edx, 42
	int 0x80
	
	mov eax, 1
	xor edx, edx
	int 0x80
