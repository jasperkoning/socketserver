 #include "Socket.h"
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/stat.h>
#include <cstring>
#include <cstdio>
#include <unistd.h>
#include <LightMessaging/LM.h>
#include <UIKit/UIApplication.h>

struct Addr_un : public sockaddr_un
{
	Addr_un(char const *path)
	{
		memset(this, 0, sizeof(struct sockaddr_un));
		sun_family = AF_UNIX;
		strcpy(sun_path, path);
	}
};

// static
int Socket::accept(char const *path)
{
	Addr_un addr(path);
	Socket s;
	unlink(addr.sun_path);
	bind(s._socket, (struct sockaddr *)(&addr), SUN_LEN(&addr));
	chmod(addr.sun_path, 0777);
	listen(s._socket, 1);
	int client = ::accept(s._socket,0,0);
	unlink(addr.sun_path);
	return client;
}

Socket::Socket()
:
	_socket(socket(PF_UNIX,SOCK_STREAM,0))
{}

void Socket::connect(char const *path)
{
	Addr_un address(path);
	::connect(_socket, (struct sockaddr *)(&address), SUN_LEN(&address));
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

void Socket::read()
{
	for (;;)
	{
		uint32_t size;
		if (!receive(&size, sizeof(size)))
			break;
		char *data = new char[size + 1];
		if (!receive(data, size))
			break;
		data[size] = '\0';
		SEL sel = sel_registerName(data);
		[[UIApplication sharedApplication] performSelectorOnMainThread:sel withObject:0 waitUntilDone:YES];
		delete[] data;
	}
}

template bool Socket::receive<char>(char *data, size_t size);
template bool Socket::receive<uint32_t>(uint32_t *data, size_t size);
