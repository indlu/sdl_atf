.PHONY: test

PROJECT=atf

QMAKE=/usr/local/Qt-5.4.1/bin/qmake
#QMAKE=/home/arv/Qt/5.4/gcc/bin/qmake

SOURCES= lua_interpreter.cc \
				 main.cc \
         marshal.cc \
         network.cc \
         qtdynamic.cc \
         qtlua.cc \
         timers.cc

all: interp

interp: $(PROJECT).mk $(SOURCES)
	make -f $<

clean:
	rm -f $(PROJECT).mk
	rm -f	*.o moc_*.cpp *.aux *.log
	rm -f test/out/*.out
	-make -C test clean

distclean: clean
	rm -f	interp libqttest.so
	-make -C test distclean

test/Makefile: test/test.pro
	$(QMAKE) $< -o $@

libqttest.so: $(SOURCES) test/Makefile
	make -C test
	ln -sf test/libqttest.so.1.0.0 libqttest.so

test: interp libqttest.so test/testbase.lua \
	    test/dynamic.lua test/connect.lua test/network.lua
	./run_tests.sh

$(PROJECT).mk: $(SOURCES) $(PROJECT).pro
	$(QMAKE) $(PROJECT).pro -o $@
