debflags = -f -debn socketserver
contents = /usr/local/include/Socket.h /usr/local/include/socketserver.h /usr/local/lib/libsocket.dylib /usr/local/bin/socktst
include /opt/default.mk

all: p i

build/%.o: %.mm
	$(compile_print) && $(CXX) -I. -I../substitute/substrate -I/usr/local/include -I/opt/theos/vendor/include -fvisibility=hidden -c $< -o $@

build/%.o: %.c
	$(compile_print) && clang -c $< -o $@  -I/opt/theos/vendor/include

%/socktst: build/main.o
	$(link_print) && clang $< -o $@ -L$(dir $@)/../lib -lsocket -framework CoreFoundation

%/socketserver.h: socketserver.h
	@echo $< && cp $< $@

%/libsocket.dylib: build/Socket.o build/layer.o
	$(link_print) && $(CXX) -L/usr/lib -shared -F/System/Library/PrivateFrameworks $(addprefix -framework ,UIKit Foundation AudioToolbox AppSupport IOKit) $^ -o $@

