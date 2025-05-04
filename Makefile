CC= g++
SOURCES=parser.cpp main.cpp tokens.cpp Codigo.cpp
TESTDIR=./test

all: parser test

.PHONY: clean test

clean:
	rm parser.cpp parser.hpp parser tokens.cpp parser.output *~

parser.cpp parser.hpp: parser.y
	bison -r all -Wcounterexamples --defines=$(subst cpp,h,$@) -o $@ $^

tokens.cpp: tokens.l parser.hpp
	flex --yylineno -o $@ $<

parser: $(SOURCES)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $(SOURCES) -ll

test: $(TESTDIR)/*.in
	@for f in $^ ; do \
		echo "$${f} probando:" ;\
        ./parser < $${f} ; \
        done



