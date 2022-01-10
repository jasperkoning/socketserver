#include "Socket.h"
#include <Foundation/Foundation.h>
#include <LightMessaging/LightMessaging.h>
#include <LightMessaging/LM.h>
#include <pthread.h>

void *readFromSocket(void *data)
{
	Socket *socket(reinterpret_cast<Socket *>(data));
	socket->read();
	delete socket;
	return NULL;
}

// onPID creates a socket /tmp/.jk.<pid> on each received PID
static void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	printf("%s\n","tst");
	void *data = LMMessageGetData(message);
	auto path = (const char *)((const UInt8*)data ?: (const UInt8 *)&data);
	Socket *socket = new Socket(path);
	socket->connect();
	pthread_t thread;
	pthread_create(&thread, NULL, &readFromSocket, socket);
}

extern "C"
__attribute__ ((visibility("default")))
void launchSocketServer(char const *name)
{
	// LMStartService only works from SpringBoard!
	LMStartService((char *)name, CFRunLoopGetMain(), (CFMachPortCallBack)onPID);
}

extern "C"
__attribute__ ((visibility("default")))
int createSocket(char const *name, int pid)
{
	char path[30];
	sprintf(path, "/tmp/.jk.%d", pid);
	Socket s(path);
	s.listen();
	// create socket from remote server
	kern_return_t kr = jkmsgsend(name, 0x1111, path, strlen(path) + 1);
	if (kr != 0)
	{
		mach_error("msgsend: ", kr);
		printf("try: inject SpringBoard socket.dylib\n");
		remove(path);
		return -1;
	}
	// accept socket
	return s.accept();
}

