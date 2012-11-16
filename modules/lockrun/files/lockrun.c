/*
 * $Id: //websites/unixwiz/unixwiz.net/webroot/tools/lockrun.c#6 $
 *
 * written by :	Stephen J. Friedl
 *              Software Consultant
 *		Southern California USA
 *              steve@unixwiz.net
 *		http://www.unixwiz.net/tools/
 *
 *	===================================================================
 *	======== This software is in the public domain, and can be ========
 *	======== used by anybody for any purpose                   ========
 *	===================================================================
 *
 *	Lockrun: This program is used to launch a program out with a lockout
 *	so that only one can run at a time. It's mainly intended for use out
 *	of cron so that our five-minute running jobs which run long don't get
 *	walked on. We find this a *lot* with Cacti jobs which just get hung
 *	up: it's better to miss a polling period than to stack them up and
 *	slow each other down.
 *
 *	So we use a file which is used for locking: this program attempts to
 *	lock the file, and if the lock exists, we have to either exit with
 *	an error, or wait for it to release.
 *
 *		lockrun --lockfile=FILE -- my command here
 *
 * COMMAND LINE
 * ------------
 *
 * --lockfile=F
 *
 *	Specify the name of a file which is used for locking. The file is
 *	created if necessary (with mode 0666), and no I/O of any kind is
 *	done. The file is never removed.
 *
 * --maxtime=N
 *
 *	The script being controlled should run for no more than <N> seconds,
 *	and if it's beyond that time, we should report it to the standard
 *	error (which probably gets routed to the user via cron's email).
 *
 * --wait
 *
 *	When a lock is hit, we normally exit with error, but --wait causes
 *	it to loop until the lock is released.
 *
 * --sleep=N
 *
 *	When using --wait, will sleep <N> seconds between attempts to acquire
 *	the lock.
 *
 * --retries=N
 *
 *	When using --wait, will try only <N> attempts of acquiring the lock.
 *
 * --verbose
 *
 *	Show a bit more runtime debugging.
 *
 * --quiet
 *
 *	Don't show "run is locked" error if things are busy; keeps cron from
 *	overwhelming you with messages if lockrun overlap is not uncommon.
 *
 * --
 *
 *	Mark the end of the options: the command to run follows.
 *
 *
 * VERSION HISTORY
 *
 * 1.1.1 2012/09/05; added setsid() to make the controlled process a process
 *			group leader
 * 1.1.0 2012/09/05; added --version and --help; added --retries (thanks Dov Murik)
 * 1.0.3 2010/11/20; added --quiet parameter
 * 1.0.2 2009/06/25; added lockf() support for Solaris 10 (thanks Michal Bella)
 * 1.0.1 2006/06/03; initial release
 *
 */

#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/file.h>

static const char Version[] = "lockrun 1.1.1 - 2012-09-05 - steve@unixwiz.net";

#ifndef __GNUC__
# define __attribute__(x)	/* nothing */
#endif


#define STRMATCH(a,b)		(strcmp((a),(b)) == 0)

#define UNUSED_PARAMETER(v)	((void)(v))

#define	TRUE	1
#define	FALSE	0

static const char	*lockfile = 0;
static int		wait_for_lock = FALSE;
static mode_t		openmode = 0666;
static int		sleeptime = 10;		/* seconds */
static int		retries = 0;
static int		Verbose = FALSE;
static int		Maxtime  = 0;
static int		Quiet = FALSE;

static char *getarg(char *opt, char ***pargv);

static void die(const char *format, ...)
		__attribute__((noreturn))
		__attribute__((format(printf, 1, 2)));

#ifdef __sun
# define WAIT_AND_LOCK(fd) lockf(fd, F_TLOCK,0)
#else
# define WAIT_AND_LOCK(fd) flock(fd, LOCK_EX | LOCK_NB)
#endif

static const char *const helptext[] = {
	"Usage: lockrun [options] -- command args...",
	"",
	"  --help        Show this brief help listing",
	"  --version     Report the version info",
	"  --            Mark the end of lockrun options; command follows",
	"  --verbose     Show a bit more runtime debugging",
	"    -V",
	"  --quiet       Exit quietly (and with success) if locked",
	"    -q",
	"  --lockfile=F  Specify lockfile as file <F>",
	"    -L=F",
	"  --wait        Wait for lockfile to appear (else exit on lock)",
	"    -W",
	"",
	" Options with --wait:",
	"",
	"  --sleep=T     Sleep for <T> seconds on each wait loop",
	"    -S=T",
	"  --retries=N   Attempt <N> retries in each wait loop",
	"    -R=N",
	"  --maxtime=T   Wait for at most <T> seconds for a lock, then exit",
	0,
};

static void show_help(const char *const *);

int main(int argc, char **argv)
{
	char	*Argv0 = *argv;
	int	rc;
	int	lfd;
	pid_t	childpid;
	time_t	starttime;
	int	attempts = 0;

	UNUSED_PARAMETER(argc);

	time(&starttime);

	for ( argv++ ; *argv ; argv++ )
	{
		char    *arg = *argv;
		char	*opt = strchr(arg, '=');

		/* the -- token marks the end of the list */

		if ( strcmp(*argv, "--") == 0 )
		{
			argv++;
			break;
		}

		if (opt) *opt++ = '\0'; /* pick off the =VALUE part */

		if ( STRMATCH(arg, "--version") )
		{
			puts(Version);
			exit(EXIT_SUCCESS);
		}

		else if ( STRMATCH(arg, "--help"))
		{
			show_help(helptext);
			exit(EXIT_SUCCESS);
		}

		else if ( STRMATCH(arg, "-L") || STRMATCH(arg, "--lockfile"))
		{
			lockfile = getarg(opt, &argv);
		}

		else if ( STRMATCH(arg, "-W") || STRMATCH(arg, "--wait"))
		{
			wait_for_lock = TRUE;
		}

		else if ( STRMATCH(arg, "-S") || STRMATCH(arg, "--sleep"))
		{
			sleeptime = atoi(getarg(opt, &argv));
		}

		else if ( STRMATCH(arg, "-R") || STRMATCH(arg, "--retries"))
		{
			retries = atoi(getarg(opt, &argv));
		}

		else if ( STRMATCH(arg, "-T") || STRMATCH(arg, "--maxtime"))
		{
			Maxtime = atoi(getarg(opt, &argv));
		}

		else if ( STRMATCH(arg, "-V") || STRMATCH(arg, "--verbose"))
		{
			Verbose++;
		}

		else if ( STRMATCH(arg, "-q") || STRMATCH(arg, "--quiet"))
		{
			Quiet = TRUE;
		}

		else
		{
			die("ERROR: \"%s\" is an invalid cmdline param", arg);
		}
	}

	/*----------------------------------------------------------------
	 * SANITY CHECKING
	 *
	 * Make sure that we have all the parameters we require
	 */
	if (*argv == 0)
		die("ERROR: missing command to %s (must follow \"--\" marker) ", Argv0);

	if (lockfile == 0)
		die("ERROR: missing --lockfile=F parameter");

	/*----------------------------------------------------------------
	 * Open or create the lockfile, then try to acquire the lock. If
	 * the lock is acquired immediately (==0), then we're done, but
	 * if the lock is not available, we have to wait for it.
	 *
	 * We can either loop trying for the lock (for --wait), or exit
	 * with error.
	 */

	if ( (lfd = open(lockfile, O_RDWR|O_CREAT, openmode)) < 0)
		die("ERROR: cannot open(%s) [err=%s]", lockfile, strerror(errno));

	while ( WAIT_AND_LOCK(lfd) != 0 )
	{
		attempts++;

		if ( ! wait_for_lock )
		{
			if ( Quiet)
				exit(EXIT_SUCCESS);
			else
				die("ERROR: cannot launch %s - run is locked", argv[0]);
		}

		if ( retries > 0 && attempts >= retries )
		{
			die("ERROR: cannot launch %s - run is locked (after %d attempts)", argv[0], attempts);
		}

		/* waiting */
		if ( Verbose ) printf("(locked: sleeping %d secs, after attempt #%d)\n", sleeptime, attempts);

		sleep(sleeptime);
	}

	fflush(stdout);

	/* run the child */


	if ( (childpid = fork()) == 0 )
	{
		/* IN THE CHILD */

		close(lfd);		/* don't need the lock file */

		/* Make ourselves a process group leader so that this and all
		 * child processes can be sent a signal as a group. This may
		 * be used someday to support a --kill option, though this is
		 * is still tricky.
		 *
		 * PORTING NOTE: if "setsid" is undefined on your platform,
		 * just comment it out and send me an email with info about
		 * the build environment.
		 */
		(void) setsid();

		execvp(argv[0], argv);
	}
	else if ( childpid > 0 )
	{
		/* IN THE PARENT */

		time_t endtime;
		pid_t  pid;

		if ( Verbose )
		    printf("Waiting for process %ld\n", (long) childpid);

		pid = waitpid(childpid, &rc, 0);

		time(&endtime);

		endtime -= starttime;

		if ( Verbose || (Maxtime > 0  &&  endtime > Maxtime) )
		    printf("pid %d exited with status %d (time=%ld sec)\n", pid, rc, endtime);
	}
	else
	{
		die("ERROR: cannot fork [%s]", strerror(errno));
	}

	exit(rc);
}


/*! \fn static char *getarg(char *opt, char ***pargv)
 *  \brief A function to parse calling parameters
 *
 *	This is a helper for the main arg-processing loop: we work with
 *	options which are either of the form "-X=FOO" or "-X FOO"; we
 *	want an easy way to handle either one.
 *
 *	The idea is that if the parameter has an = sign, we use the rest
 *	of that same argv[X] string, otherwise we have to get the *next*
 *	argv[X] string. But it's an error if an option-requiring param
 *	is at the end of the list with no argument to follow.
 *
 *	The option name could be of the form "-C" or "--conf", but we
 *	grab it from the existing argv[] so we can report it well.
 *
 * \return character pointer to the argument
 *
 */
static char *getarg(char *opt, char ***pargv)
{
	const char *const optname = **pargv;

	/* option already set? */
	if (opt) return opt;

	/* advance to next argv[] and try that one */
	if ((opt = *++(*pargv)) == 0)
		die("ERROR: option %s requires a parameter", optname);

	return opt;
}

/*
 * die()
 *
 *	Given a printf-style argument list, format it to the standard error,
 *	append a newline, then exit with error status.
 */

static void die(const char *format, ...)
{
va_list	args;

	va_start(args, format);
	vfprintf(stderr, format, args);
	putc('\n', stderr);
	va_end(args);

	exit(EXIT_FAILURE);
}

static void show_help(const char * const *p)
{
	puts(Version);
	puts("");

	for ( ; *p; p++ )
	{
		puts(*p);
	}
}
