#include "Socket.h"
//#include <stdint.h>
//#include <objc/runtime.h>
#import <UIKit/UIApplication.h>

void *readFromSocket(void *data)
{
	Socket *socket(reinterpret_cast<Socket *>(data));
	for (;;)
	{
		uint32_t size;
		if (!socket->receive(&size, sizeof(size)))
			break;
		char *data = new char[size + 1];
		if (!socket->receive(data, size))
			break;
		data[size] = '\0';
		SEL sel = sel_registerName(data);
		[[UIApplication sharedApplication] performSelectorOnMainThread:sel withObject:0 waitUntilDone:YES];
		delete[] data;
	}
	delete socket;
	return NULL;
}
