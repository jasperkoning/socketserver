#include "socketserver.h"
#include <stdio.h>
//#include <LightMessaging/LightMessaging.h>

int main()
{
	printf("%d", createSocket("jk.socket"));
	// onPID creates a socket /tmp/.jk.<pid> on each received PID
	launchSocketServer("jk.socket");
}
