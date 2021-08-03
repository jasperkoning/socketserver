#include <LightMessaging/LM.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/stat.h>

extern "C"
__attribute__ ((visibility("default")))
int socketFromServer(char const *name)
{
	int server = socket(PF_UNIX, SOCK_STREAM, 0);
	struct sockaddr_un address;
	memset(&address, 0, sizeof(address));
	address.sun_family = AF_UNIX;
	sprintf(address.sun_path, "/tmp/.jk.%u", getpid());
	unlink(address.sun_path);
	bind(server, (struct sockaddr *)(&address), SUN_LEN(&address));
	chmod(address.sun_path, 0777);
	listen(server, 1);
	char str[10];
	sprintf(str, "%d", getpid());
	mach_port_t bs = MACH_PORT_NULL;
	task_get_bootstrap_port(mach_task_self(), &bs);
	mach_port_t socketServer;
	bootstrap_look_up(bs, name, &socketServer);
	jkmsgsend(socketServer, 0x1111, str, strlen(str) + 1);
	int client = accept(server, 0, 0);
	unlink(address.sun_path);
	close(server);
	return client;
}
