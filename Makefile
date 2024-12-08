snake: snake.o
	ld -o snake snake.o
	
snake.o: snake.asm
	nasm -f elf64 snake.asm
	
clear:
	rm --force snake.o snake
