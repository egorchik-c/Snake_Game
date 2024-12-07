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

	line db "w"
	buff db 1
	
section .bss
	term resb 20
	NOBLOCK equ 0x800
	
section .text
	global _start
 
_start:
	mov eax, 0x5401
	mov ebx, 0
	lea ecx, [term]
	int 0x80
	
	mov eax, [term]
	or eax, NOBLOCK
	mov [term], eax
	
	mov eax, 0x5402
	mov ebx, 0
	lea ecx, [term]
	int 0x80
	
game_loop:
	call terminal_input
	
	mov al, [buff]
	cmp al, "w"
	je set_up
	cmp al, "a"
	je set_left
	cmp al, "d"
	je set_right
	cmp al, "s"
	je set_down
	jmp move_snake
	
set_up:
	mov byte [line], "w"
	jmp move_snake
	
set_left:
	mov byte [line], "a"
	jmp move_snake
	
set_right:
	mov byte [line], "d"
	jmp move_snake
	
set_down:
	mov byte [line], "s"
	jmp move_snake
	
move_snake:
	call clear_snake
	
	mov al, [line]
	cmp al, "w"
	je move_up
	cmp al, "a"
	je move_left
	cmp al, "d"
	je move_right
	cmp al, "s"
	je move_down
	jmp draw_snake
	
move_up:
	dec byte [snake_y]
	jmp draw_snake
	
move_left:
	dec byte [snake_x]
	jmp draw_snake

move_right:
	inc byte [snake_x]
	jmp draw_snake
	
move_down:
	inc byte [snake_y]
	
draw_snake:
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

	jmp game_loop
	
clear_snake:
	movzx eax, byte [snake_y]
	mov ebx, 24
	mul ebx
	movzx edi, byte [snake_x]
	add eax, edi
	
	lea esi, byte [field]
	add esi, eax
	mov byte [esi], " "
	ret

terminal_input:
	mov eax, 3
	mov ebx, 0
	lea ecx, [buff]
	mov edx, 1
	int 0x80
	ret
	
