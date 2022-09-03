#include <c/test.hpp>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"
extern "C" void _start() {
	char *videoMemory = reinterpret_cast<char *>(0xB8000);
	*videoMemory = 'X';
	videoMemory += 2;
	*videoMemory = 'N';
}
#pragma clang diagnostic pop