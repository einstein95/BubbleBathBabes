.PHONY: all clean verify

all: rom.nes verify

rom.o: bbb.asm
	ca65 bbb.asm -o rom.o

rom.nes: rom.o
	ld65 rom.o -t nes -o rom.nes

verify: rom.nes
	sha1sum -c rom.sha1

clean:
	rm -f rom.o rom.nes