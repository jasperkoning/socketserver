#include <sys/socket.h>

#ifdef __cplusplus
//#include "SocketServer.h"
extern "C"
#endif
int createSocket(char const *name, int pid);

#ifdef __cplusplus
extern "C"
#endif
// only works in SpringBoard!
void launchSocketServer(char const *name);
