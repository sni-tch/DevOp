all: class

class: main.o class.o
	x86_64-linux-gnu-g++ -o class main.o Class.o

main.o: main.cpp
	x86_64-linux-gnu-g++ -g -Wall -c main.cpp

class.o: Class.cpp Class_H.h
	x86_64-linux-gnu-g++ -g -Wall -c Class.cpp

clean:
	rm -rf *.o *.elf
