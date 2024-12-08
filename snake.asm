section .data
	field db "#########################################", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#                                       #", 0xa
	db "#########################################", 0xa
	field_len equ $ - field

	clr db 0x1b, "[2J", 0x1b, "[H", 0
	clr_len equ $ - clr

	snake_x db 20
	snake_y db 10
	line db "s"
	buff db 1, 0

section .text
	global _start

_start:
	call draw_snake
	call print_field
	
move_snake:
 	call read_input
 	call valid_input
 	call draw_snake
 	call print_field
 	jmp exit
 	

read_input:
	mov eax, 3               
	mov ebx, 0               
	lea ecx, buff      
	mov edx, 1               
	int 0x80
	ret  
	
valid_input:
	mov al, byte [buff]
	cmp al, "w"
	je set_up
	cmp al, "s"
	je set_down
	cmp al, "a"
	je set_right
	cmp al, "d"
	je set_left
	ret
	
set_up:
	dec byte [snake_y]
	ret
	
set_down:
	inc byte [snake_y]
	ret
	
set_right:
	dec byte [snake_x]
	ret
	
set_left:
	inc byte [snake_x]
	ret

draw_snake:
	movzx eax, byte [snake_y]
	mov ebx, 42
	mul ebx
	movzx ebx, byte [snake_x]
	add eax, ebx


	mov byte [field + eax], byte "O"
	ret

print_field:
	call clear_screen
	mov eax, 4
	mov ebx, 1
	mov ecx, field
	mov edx, field_len
	int 0x80
	ret

clear_screen:
	mov eax, 4
	mov ebx, 1
	lea ecx, clr
	mov edx, clr_len
	int 0x80
	ret

exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80
