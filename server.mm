#include "Socket.h"
#include <Foundation/Foundation.h>
#include <LightMessaging/LightMessaging.h>
#include <LightMessaging/LM.h>
#include <UIKit/UIApplication.h>
#include <pthread.h>
#include <inject.h>

#define SERVER_NAME "jk.socket"

static void *readFromSocket(void *arg)
{
	auto *sock = static_cast<Socket *>(arg);
	while (sock->read())
	{
		SEL sel =
			sel_registerName(sock->data());
		[[UIApplication sharedApplication] performSelectorOnMainThread:sel withObject:0 waitUntilDone:YES];
	}
	delete sock;

	Socket sock2("/tmp/.jk2");
//	sock2.

	return NULL;
}

// onPID creates a socket /tmp/.jk.<pid> on each received PID
static void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	void *data = LMMessageGetData(message);
	auto path = (const char *)((const UInt8*)data ?: (const UInt8 *)&data);
	Socket *sock = new Socket(path);
	sock->connect();
	pthread_t thread;
	pthread_create(&thread, NULL, &readFromSocket, sock);
}

extern "C"
__attribute__ ((visibility("default")))
void launchSocketServer()
{
	// LMStartService only works from SpringBoard!
	LMStartService((char *)SERVER_NAME, CFRunLoopGetMain(), (CFMachPortCallBack)onPID);
}

extern "C"
__attribute__ ((visibility("default")))
int createSocket(int pid)
{
	char path[30];
	sprintf(path, "/tmp/.jk.%d", pid);
	Socket sock(path);
	sock.listen();
	// create socket from remote server
	kern_return_t kr = jkmsgsend(SERVER_NAME, 0x1111, path, strlen(path) + 1);
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

