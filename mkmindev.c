#include <sys/stat.h>
#include <sys/sysmacros.h>
#include <errno.h>
#include <error.h>
#define ckerror(msg) if (errno) error(1, errno, msg)
int main() {
	mkdir("dev",         00111); ckerror("mkdir dev");
	mknod("dev/null",    00666 | S_IFCHR, makedev(1, 3)); ckerror("mknod ""dev/null");
	mknod("dev/zero",    00666 | S_IFCHR, makedev(1, 5)); ckerror("mknod ""dev/zero");
	mknod("dev/random",  00666 | S_IFCHR, makedev(1, 9)); ckerror("mknod ""dev/random");
	mknod("dev/urandom", 00666 | S_IFCHR, makedev(1, 9)); ckerror("mknod ""dev/urandom");
}