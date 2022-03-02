#include "Socket.h"
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/stat.h>
#include <cstring>
#include <cstdio>
#include <unistd.h>
#include <LightMessaging/LM.h>
#include <UIKit/UIApplication.h>

Socket::Socket(char const *path)
:
	_socket(
		::socket(PF_UNIX,SOCK_STREAM, 0)),
	_data(1, '\0')
{
	memset(&_addr, 0, sizeof(struct sockaddr_un));
	_addr.sun_family = AF_UNIX;
	strcpy(_addr.sun_path, path);
}

Socket::~Socket()
{
	close(_socket);
}

int Socket::accept() const
{
	int client = ::accept(_socket, 0, 0);
	unlink(_addr.sun_path);
	return client;
}

void Socket::listen() const
{
	unlink(_addr.sun_path);
	bind(_socket, reinterpret_cast<const sockaddr *>(&_addr), SUN_LEN(&_addr));
	chmod(_addr.sun_path, 0777);
	::listen(_socket, 1);
}

void Socket::connect() const
{
	::connect(_socket, reinterpret_cast<const sockaddr *>(&_addr), SUN_LEN(&_addr));
}

bool Socket::read()
{
	uint32_t size;
	if (!receive(&size, sizeof(size)))
		return false;
	_data =
		std::vector<char>(size + 1, '\0');
	if (!receive(&_data[0], size))
		return false;
	return true;
}

void Socket::send(char const *msg) const
{
	::send(_socket, msg, strlen(msg), 0);
}

template <typename T>
bool Socket::receive(T *t, size_t size) const
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

template bool Socket::receive<char>(char *data, size_t size) const;
template bool Socket::receive<uint32_t>(uint32_t *data, size_t size) const;
