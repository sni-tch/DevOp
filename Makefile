all: class

class: main.o class.o
	g++ -g -Wall main.o Class.o -o class.elf

main.o: main.cpp
	g++ -g -Wall -c main.cpp

class.o: Class.cpp Class_H.h
	g++ -g -Wall -c Class.cpp

clean:
	rm -rf *.o *.elf

