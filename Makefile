BulgarianSolitaire:	main.o play_game.o mod.o print_pile.o remove_zero.o sort.o check.o
	rm main.o
	rm play_game.o
	rm mod.o
	rm print_pile.o
	rm remove_zero.o
	rm sort.o
	rm check.o
	gcc -c main.s
	gcc -c play_game.s
	gcc -c mod.s
	gcc -c print_pile.s
	gcc -c remove_zero.s
	gcc -c sort.s
	gcc -c check.s
	gcc -o BulgarianSolitaire main.o play_game.o mod.o print_pile.o remove_zero.o sort.o check.o
	
clean:
	rm *.o BulgarianSolitaire
