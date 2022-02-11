debflags = -f -debn socketserver
%/libsocket.dylib: build/Socket.o build/layer.o
	$(link_print) && $(CXX) -L/usr/lib -shared -F/System/Library/PrivateFrameworks $(addprefix -framework ,UIKit Foundation AudioToolbox AppSupport IOKit) $^ -o $@

