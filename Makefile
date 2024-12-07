all: class

class: main.o class.o
	g++ -o class main.o Class.o

main.o: main.cpp
	g++ -g -Wall -c main.cpp

class.o: Class.cpp Class_H.h
	g++ -g -Wall -c Class.cpp

clean:
	rm -rf *.o *.elf
