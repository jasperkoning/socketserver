#ifdef __cplusplus
//#include "SocketServer.h"
extern "C"
#endif
int createSocket(char const *name, int pid);

#ifdef __cplusplus
extern "C"
#endif
void launchSocketServer(char const *name);
