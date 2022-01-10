#include "socketserver.h"
#include <stdio.h>
#include <unistd.h>
#include <LightMessaging/LM.h>

void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	fprintf(stderr,"hi\n");
	FILE *fd = fopen("/tmp/ton", "w");
	fprintf(fd, "hi");
	fclose(fd);
}

int main(int argc, char **argv)
{
	char const *name = "JKJKJK";
	if (argc == 1)
	{		
		kern_return_t br = LMStartService((char *)name, CFRunLoopGetCurrent(), (CFMachPortCallBack)onPID);
		char const *err = bootstrap_strerror(br);
		printf("%s\n", err);
		getchar();
		return 0;
	}
	// char path[30];
	// sprintf(path, "/tmp/.jk.%d", getpid());
	char const *path = "hi";
	
	// create socket from remote server
	// mach_error("m:",jkmsgsend(name, 0x1111, path, strlen(path) + 1));
	LMConnection connection =
		{
			MACH_PORT_NULL,
			"JKJKJK"
		};
	mach_error("m:",LMConnectionSendOneWay(&connection, 0x1111, path, strlen(path) + 1));
	getchar();
	
	// if (argc == 1)
		// launchSocketServer("jk.socket");
	// else
		// printf("%d", createSocket("jk.socket", getpid()));
	// getchar();
	// // onPID creates a socket /tmp/.jk.<pid> on each received PID
}
