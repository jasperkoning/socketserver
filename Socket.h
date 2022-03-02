#include <stddef.h>
#include <sys/un.h>
#include <vector>

class Socket
{
	const int _socket;
	sockaddr_un _addr; // could be const and initialized using lambda
	std::vector<char> _data;

public:
	Socket(char const *path);
	Socket(int socket);

	~Socket();

	int socket() const;

	void listen() const;

	void connect() const;

	int accept() const;

	bool read();

	char const *data() const;

	void send(char const *msg) const;

private:
	template <typename T>
	bool receive(T *t, size_t size) const;
};

inline char const *Socket::data() const
{
	return _data.data();
}

inline int Socket::socket() const
{
	return _socket;
}
