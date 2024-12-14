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

	apple_x db 30
	apple_y db 7
	apple_sign db "@"

	line db "s"
	buff db 1

section .bss
	snake_xy resb 100
	head_xy resb 2
	prev_x resb 1
	prev_y resb 1

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
	call draw_apple
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

	mov byte [prev_x], 20
	mov byte [prev_y], 8
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
	
update_body:
    movzx ecx, byte [snake_size]
    dec ecx
    lea esi, snake_xy

	update_loop:
		movzx eax, byte [esi + ecx * 2 - 2]
		mov byte [esi + ecx * 2], al
		movzx eax, byte [esi + ecx * 2 - 1]
		mov byte [esi + ecx * 2 + 1], al

		dec ecx
		jnz update_loop

	call head_update
	
    ret


set_down:
	call update_prev
    call update_body
    inc byte [snake_xy + 1]
	call check_apple
    call check_field
    ret

set_up:
	call update_prev
    call update_body
    dec byte [snake_xy + 1]
	call check_apple
    call check_field
    ret

set_left:
	call update_prev
    call update_body
    dec byte [snake_xy]
	call check_apple
    call check_field
    ret

set_right:
	call update_prev
    call update_body
    inc byte [snake_xy]
	call check_apple
    call check_field
    ret

head_update:
	lea esi, snake_xy
	lea edi, head_xy

	mov bl, byte [esi]
	mov byte[edi], bl
	mov bl, byte [esi + 1]
	mov byte[edi + 1], bl

	ret

update_prev:
	lea esi, snake_xy
	movzx ecx, byte [snake_size]
	dec ecx

	movzx ebx, byte [esi + ecx * 2]
	mov byte [prev_x], bl
	movzx ebx, byte [esi + ecx * 2 + 1]
	mov byte [prev_y], bl
	ret 

check_apple:
	lea esi, head_xy
	movzx eax, byte [esi]
	movzx ebx, byte [apple_x]
	cmp eax, ebx
	jne not_eaten

	movzx eax, byte [esi + 1]
	movzx ebx, byte [apple_y]
	cmp eax, ebx
	jne not_eaten
	
	call grow_snake

	not_eaten:
		ret

grow_snake:
    lea esi, snake_xy
    movzx eax, byte [snake_size]
    dec eax

    
    movzx ebx, byte [esi + eax * 2]
    movzx ecx, byte [esi + eax * 2 + 1]

    
    inc byte [snake_size]

    movzx eax, byte [snake_size]
    dec eax
    mov byte [esi + eax * 2], bl 
    mov byte [esi + eax * 2 + 1], cl 

    ret


place_apple:
    mov eax, 42
    call random
    add al, 1
    mov byte [apple_x], al

    
    mov eax, 20
    call random
    add al, 1
    mov byte [apple_y], al
    ret

random:
	mov eax, 1
    xor edx, edx
    xor ebx, ebx
    int 0x80
    ret

draw_apple:
    movzx eax, byte [apple_y]
    mov ebx, 42
    mul ebx
    movzx ebx, byte [apple_x]
    add eax, ebx
	mov dl, byte [apple_sign]
    mov byte [field + eax], dl
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
	dec edi
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
		cmp ecx, edi
		jle draw_loop

	ret	
    

draw_snake_prev:
    movzx eax, byte [prev_y]
    mov ebx, 42
    mul ebx
    movzx ebx, byte [prev_x]
    add eax, ebx
    mov byte [field + eax], " " 
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
