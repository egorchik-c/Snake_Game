section .data
	field db "#########################", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#                       #", 0xa
		db "#########################", 0xa
	field_len equ $ - field
	
section .text
	global _start
	
_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, field
	mov edx, field_len
	int 0x80
	
	mov eax, 1
	xor ebx, ebx
	int 0x80
