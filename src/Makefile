CC=gcc
BISON=bison
FLEX=flex

BISON_FILE=ocl.y
FLEX_FILE=ocl.l
OUTPUT=compiler.out

all: clean $(OUTPUT)

$(OUTPUT): ocl.tab.c lex.yy.c
	$(CC) -o $(OUTPUT) ocl.tab.c -ly -ll

ocl.tab.c: $(BISON_FILE)
	$(BISON) -d $(BISON_FILE)

lex.yy.c: $(FLEX_FILE)
	$(FLEX) $(FLEX_FILE)

clean:
	rm -f $(OUTPUT) ocl.tab.c ocl.tab.h lex.yy.c