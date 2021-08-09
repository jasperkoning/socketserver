#include "SocketServer.h"

extern "C"
__attribute__ ((visibility("default")))
void launchSocketServer(char const *name)
{
	SocketServer::launch(name);
}

extern "C"
__attribute__ ((visibility("default")))
int createSocket(char const *name, int pid)
{
	SocketServer server(name);
	return server.createSocket(pid);
}

