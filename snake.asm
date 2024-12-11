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

	clr db 0x1b, "[1J", 0x1b, "[H"
	clr_len equ $ - clr

	snake_size db 3
	line db "s"
	buff db 1

section .bss
	snake_xy resb 100
	prev_xy resb 100
section .text
	global _start

_start:
	call init_head
	call draw_snake
	call print_field
	
move_snake:
 	call read_input
 	call valid_input
 	call clear_screen
 	call draw_snake
 	call draw_snake_prev
 	call print_field
 	jmp move_snake
 	
init_head:
	lea esi, snake_xy
	mov byte [esi], 20
	mov byte [esi + 1], 10
	mov byte [esi + 2], 20
	mov byte [esi + 3], 9
	mov byte [esi + 4], 20
	mov byte [esi + 5], 8

	lea esi, prev_xy
	mov byte [esi], 20
	mov byte [esi + 1], 10
	ret               

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
	je set_left
	cmp al, "d"
	je set_right
	cmp al, "q"
	je exit
	ret
	
set_up:
    mov al, [snake_xy + 1]
    mov [prev_xy + 1], al
    dec byte [snake_xy + 1]
    mov al, [snake_xy] 
    mov [prev_xy], al 
    call check_field
    ret

set_down:
    mov al, [snake_xy + 1]
    mov [prev_xy + 1], al
    inc byte [snake_xy + 1]
    mov al, [snake_xy] 
    mov [prev_xy], al 
    call check_field
    ret

set_left:
    mov al, [snake_xy]
    mov [prev_xy], al
    dec byte [snake_xy]
    mov al, [snake_xy + 1] 
    mov [prev_xy + 1], al 
    call check_field
    ret

set_right:
    mov al, [snake_xy]
    mov [prev_xy], al
    inc byte [snake_xy]
    mov al, [snake_xy + 1] 
    mov [prev_xy + 1], al 
    call check_field
    ret

check_field:
	cmp byte [snake_xy], 1
	jl exit
	cmp byte [snake_xy], 40
	jg exit
	cmp byte [snake_xy + 1], 1
	jl exit
	cmp byte [snake_xy + 1], 20
	jg exit

draw_snake:
    movzx edi, byte [snake_size]
	xor ecx, ecx

	draw_loop:
		lea esi, snake_xy
		movzx eax, byte [esi + ecx * 2 + 1]
		mov ebx, 42
		mul ebx
		movzx ebx, byte [esi + ecx * 2]
		add eax, ebx
		mov byte [field + eax], "O"
		
		inc ecx
		cmp edi, ecx
		jg draw_loop

	ret	
    

draw_snake_prev:
    movzx eax, byte [prev_xy + 1] 
    mov ebx, 42
    mul ebx
    movzx ebx, byte [prev_xy]
    add eax, ebx
   	mov byte [field + eax], byte " "
    ret

print_field:
	mov eax, 4
	mov ebx, 1
	mov ecx, field
	mov edx, field_len
	int 0x80
	ret

clear_screen:
	mov eax, 4
	mov ebx, 2
	lea ecx, clr
	mov edx, clr_len
	int 0x80
	ret

exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80
