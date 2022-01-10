#include <stddef.h>
#include <sys/un.h>


class Socket
{
	const int _socket;
	sockaddr_un _addr; // could be const and initialized using lambda

public:
	Socket(char const *path);

	~Socket();

	void listen() const;

	void connect() const;
	
	int accept() const;

	void read() const;

	template <typename T>
	bool receive(T *t, size_t size) const;
};
