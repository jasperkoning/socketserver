#include "Socket.h"
#include <LightMessaging/LM.h>

extern "C"
__attribute__ ((visibility("default")))
int socketFromServer(char const *name)
{
	char path[30];
	sprintf(path, "/tmp/.jk.%d",getpid());
	// create socket from remote server
	jkmsgsend(name, 0x1111, path, strlen(path) + 1);
	// create accepted socket
	return Socket::accept(path);
}
