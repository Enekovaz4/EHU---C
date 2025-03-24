CC= g++
SOURCES=main.cpp parser.cpp tokens.cpp Code.cpp
TESTDIR=./test

all: parser test

.PHONY: clean test

clean:
	rm parser.cpp parser.h parser tokens.cpp parser.output *~

parser.cpp parser.h: parser.y
	bison -r all -Wcounterexamples --defines=$(subst cpp,h,$@) -o $@ $^

tokens.cpp: tokens.l parser.h
	flex --yylineno -o $@ $<

parser: $(SOURCES)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $(SOURCES) -ll

test: $(TESTDIR)/*.in
	@for f in $^ ; do \
		echo "$${f} probando:" ;\
        ./parser < $${f} ; \
        done



