nasm -f elf64 stack.asm -o stack.o && ld stack.o -o stack 
echo "[*] stack has been compiled"
nasm -f elf64 sthack.asm -o sthack.o && ld sthack.o -o sthack
echo "[*] sthack has been compiled"
nasm -f elf64 main.asm -o main.o && ld main.o -o main
echo "[*] main has been compiled"
nasm -f elf64 condition.asm -o condition.o && ld condition.o -o condition
echo "[*] condition has been compiled"
nasm -f elf64 loop.asm -o loop.o && ld loop.o -o loop && ./loop
echo "[*] loop has been compiled"
