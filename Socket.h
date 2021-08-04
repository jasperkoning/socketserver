#include <stddef.h>
#include <sys/un.h>

class Socket
{
	int _socket;

public:
	static int accept(char const *path);

	Socket();

	~Socket();

	void connect(char const *path);

	template <typename T>
	bool receive(T *t, size_t size);
};
