#include "Socket.h"
#include <Foundation/Foundation.h>
#include <LightMessaging/LightMessaging.h>
#include <LightMessaging/LM.h>
#include <UIKit/UIApplication.h>
#include <pthread.h>

static void *readFromSocket(void *arg)
{
	auto *sock = static_cast<Socket *>(arg);
	for (;;)
	{
		if (!sock->read())
			break;
		SEL sel =
			sel_registerName(sock->data());
		[[UIApplication sharedApplication] performSelectorOnMainThread:sel withObject:0 waitUntilDone:YES];
	}
	delete sock;
	return NULL;
}

// onPID creates a socket /tmp/.jk.<pid> on each received PID
static void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	printf("%s\n","tst");
	void *data = LMMessageGetData(message);
	auto path = (const char *)((const UInt8*)data ?: (const UInt8 *)&data);
	Socket *sock = new Socket(path);
	sock->connect();
	pthread_t thread;
	pthread_create(&thread, NULL, &readFromSocket, sock);
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
	Socket sock(path);
	sock.listen();
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
	return sock.accept();
}

