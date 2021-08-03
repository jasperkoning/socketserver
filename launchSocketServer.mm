#include "Socket.h"
#include <UIKit/UIApplication.h>
#include <LightMessaging/LightMessaging.h>
#include <pthread.h>

static void *readFromSocket(void *data)
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


using namespace std;

// onPID creates a socket /tmp/.jk.<pid> on each received PID
void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	void *data = LMMessageGetData(message);
	auto str = (const char *)((const UInt8*)data ?: (const UInt8 *)&data);
	int pid = atoi(str);
	Socket *socket = new Socket(pid);
	pthread_t thread;
	pthread_create(&thread, NULL, &readFromSocket, socket);
}

extern "C"
__attribute__ ((visibility("default")))
void launchSocketServer(char const *name)
{
	LMStartService((char *)name, CFRunLoopGetMain(), (CFMachPortCallBack)onPID);
}


