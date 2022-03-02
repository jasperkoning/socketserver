#include "socketserver.h"
#include <stdio.h>
#include <LightMessaging/LM.h>
#include <time.h>
#include <sys/time.h>
#include <mach/mach_time.h>

double convertMachAbsoluteTimeToMilliseconds(uint64_t mach_time)
{
	mach_timebase_info_data_t _clock_timebase;
	mach_timebase_info(&_clock_timebase);
	double nanos = (mach_time * _clock_timebase.numer) / _clock_timebase.denom;
	return nanos / 1.0e6;
}

void onPID
(
	CFMachPortRef port,
	LMMessage *message,
	CFIndex size,
	void *info
);

int main(int argc, char **argv)
{
	int client = createSocket(getpid());

	if (client == -1)
		return 1;

	char const *msg = argc > 1 ? argv[1] :
		"_simulateHomeButtonPress";

	unsigned long long mat = mach_absolute_time();
	sendToSocket(client, msg);
	char output[1024];
    size_t len = recv(client, output, 1024, 0);
	printf("%f ms\n", convertMachAbsoluteTimeToMilliseconds(mach_absolute_time()-mat));
	output[len]=0;
	printf("output: %s\n",output);
	return 0;

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
	fprintf(stderr,"hi2\n");
	FILE *fd = fopen("/tmp/ton", "w");
	fprintf(fd, "hi");
	fclose(fd);
}
