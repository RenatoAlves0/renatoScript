all : renatoScript.l renatoScript.y
	clear
	flex -i renatoScript.l
	bison renatoScript.y
	gcc renatoScript.tab.c -o analisador -ll -lm
	./analisador
