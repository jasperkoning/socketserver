#include <stddef.h>

class Socket
{
	int _socket;

public:
	Socket(int pid);

	~Socket();

	template <typename T>
	bool receive(T *t, size_t size);
};
