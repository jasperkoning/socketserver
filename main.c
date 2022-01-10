#include "socketserver.h"
#include <stdio.h>
#include <unistd.h>
#include <LightMessaging/LM.h>

void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info);

int main(int argc, char **argv)
{
	if (argc == 1)
	{
		int client = createSocket("jk.socket", getpid());
		if (client == -1)
			return 1;
		char const *msg = "_simulateHomeButtonPress";
		uint32_t size = strlen(msg);
		send(client, &size, sizeof(size), 0);
		send(client, msg, size, 0);
		return 0;
	}



	char const *name = "JKJKJK";
	if (strcmp(argv[1], "serve") == 0)
	{
// THIS ONLY WORKS IN SPRINGBOARD?
		kern_return_t br = LMStartService((char *)name, CFRunLoopGetCurrent(), (CFMachPortCallBack)onPID);
		char const *err = bootstrap_strerror(br);
		printf("serve: %s\n", err);
		printf("now run %s <arg> with arg != serve\n", argv[0]);
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
	kern_return_t br = LMConnectionSendOneWay(&connection, 0x1111, path, strlen(path) + 1);
	char const *err = bootstrap_strerror(br);
	printf("%s\n", err);

	// if (argc == 1)
		// launchSocketServer("jk.socket");
	// else
		// printf("%d", createSocket("jk.socket", getpid()));
	// getchar();
	// // onPID creates a socket /tmp/.jk.<pid> on each received PID
}



void onPID(CFMachPortRef port, LMMessage *message, CFIndex size, void *info)
{
	fprintf(stderr,"hi\n");
	FILE *fd = fopen("/tmp/ton", "w");
	fprintf(fd, "hi");
	fclose(fd);
}
