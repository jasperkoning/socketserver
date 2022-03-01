#include <sys/socket.h>

#ifdef __cplusplus
//#include "SocketServer.h"
extern "C"
#endif
int createSocket(int pid);

#ifdef __cplusplus
extern "C"
#endif
void sendToSocket(int client, char const *msg);

#ifdef __cplusplus
extern "C"
#endif
// only works in SpringBoard!
void launchSocketServer();
