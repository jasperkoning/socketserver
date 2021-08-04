#include "Socket.h"
#include <Foundation/Foundation.h>
#include <LightMessaging/LightMessaging.h>
#include <pthread.h>

void *readFromSocket(void *data);

using namespace std;

// onPID creates a socket /tmp/.jk.<pid> on each received PID
void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	void *data = LMMessageGetData(message);
	auto path = (const char *)((const UInt8*)data ?: (const UInt8 *)&data);
//	int pid = atoi(path);
	Socket *socket = new Socket();
	socket->connect(path);
	pthread_t thread;
	pthread_create(&thread, NULL, &readFromSocket, socket);
}

extern "C"
__attribute__ ((visibility("default")))
void launchSocketServer(char const *name)
{
	LMStartService((char *)name, CFRunLoopGetMain(), (CFMachPortCallBack)onPID);
}


