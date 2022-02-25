#include "socketserver.h"
#include <stdio.h>
#include <LightMessaging/LM.h>

void onPID
(
	CFMachPortRef port,
	LMMessage *message,
	CFIndex size,
	void *info
);

int main(int argc, char **argv)
{
	int client =
		createSocket
		(
			"jk.socket",
			getpid()
		);

	if (client == -1)
		return 1;

	char const *msg =
		"_simulateHomeButtonPress";

	uint32_t size = strlen(msg);
	send(client, &size, sizeof(size), 0);
	send(client, msg, size, 0);


	if (argc == 1)
		return 0;



	char const *name = "JKJKJK";
	if (strcmp(argv[1], "serve") == 0)
	{
// THIS ONLY WORKS IN SPRINGBOARD?
		kern_return_t br =
			LMStartService
			(
				(char *)name,
				CFRunLoopGetCurrent(),
				(CFMachPortCallBack)onPID
			);
		char const *err = bootstrap_strerror(br);
		printf("serve: %s\n", err);
		printf
		(
			"now run %s <arg != serve>\n", 
			argv[0]
		);
		getchar();
		return 0;
	}
	char const *path = "hi";

	LMConnection connection =
		{
			MACH_PORT_NULL,
			"JKJKJK"
		};
	kern_return_t br =
		LMConnectionSendOneWay
		(
			&connection,
			0x1111,
			path,
			strlen(path) + 1
		);
	char const *err = bootstrap_strerror(br);
	printf("%s\n", err);
}



void onPID
(
	CFMachPortRef port,
	LMMessage *message,
	CFIndex size,
	void *info
)
{
	fprintf(stderr,"hi1\n");
	FILE *fd = fopen("/tmp/ton", "w");
	fprintf(fd, "hi");
	fclose(fd);
}
