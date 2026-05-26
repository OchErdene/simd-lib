all:
	nasm -f elf64 src/math.asm -o src/math.o
	gcc -o bin/main src/main.c src/math.o -no-pie -mavx2
	gcc -o bin/bench bench/bench.c src/math.o -no-pie -mavx2 -O0

clean:
	rm -f src/*.o bin/main bin/bench
