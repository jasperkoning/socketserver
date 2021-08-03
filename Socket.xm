#include "Socket.h"
#include <sys/socket.h>
#include <sys/un.h>
#include <cstring>
#include <cstdio>
#include <unistd.h>

Socket::Socket(int pid)
:
	_socket(socket(PF_UNIX,SOCK_STREAM,0))
{
	struct sockaddr_un address;
	memset(&address, 0, sizeof(address));
	address.sun_family = AF_UNIX;
	sprintf(address.sun_path, "/tmp/.jk.%d", pid);
	connect(_socket, (struct sockaddr *)(&address), SUN_LEN(&address));
}

Socket::~Socket()
{
	close(_socket);
}

template <typename T>
bool Socket::receive(T *t, size_t size)
{
	auto data = reinterpret_cast<uint8_t *>(t);
	while (size != 0)
		if (size_t writ = recv(_socket, data, size, 0))
		{
			data += writ;
			size -= writ;
		}
		else
			return false;
	return true;
}

template bool Socket::receive<char>(char *data, size_t size);
template bool Socket::receive<uint32_t>(uint32_t *data, size_t size);
