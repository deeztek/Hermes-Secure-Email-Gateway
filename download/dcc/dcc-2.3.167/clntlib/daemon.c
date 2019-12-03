/* compatibility hack for old systems lacking daemon() */

#include "dcc_defs.h"
#include "dcc_paths.h"


int
dcc_daemon(int nochdir, int noclose)
{
	int retv;

	if (!nochdir) {
		if (chdir("/") == -1)
			perror("chdir /");
	}
	retv = fork();
	if (retv == -1)
		return -1;		/* fork() failed */

	if (retv != 0)
		_exit(0);		/* parent of new child */

	/* fork again after setsid() so that the PID is not the session
	 * group leader so that opening a tty device won't make a
	 * controlling terminal. */
	setsid();
	retv = fork();
	if (retv == -1) {
		perror("fork");		/* second fork() failed */
		exit(1);		/* cannot tell caller */
	}
	if (retv != 0)
		_exit(0);		/* parent of final child */

	if (!noclose) {
		close(0);
		close(1);
		close(2);
		open(_PATH_DEVNULL, O_RDWR, 0666);
		dup2(0, 1);
		dup2(0, 2);
	}
	return 0;
}
