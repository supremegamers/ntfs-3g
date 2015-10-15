/*
    FUSE: Filesystem in Userspace
    Copyright (C) 2001-2007  Miklos Szeredi <miklos@szeredi.hu>

    This program can be distributed under the terms of the GNU LGPLv2.
    See the file COPYING.LIB.
*/

#include <unistd.h>
#include "config.h"
#include "fuse_i.h"
#include "fuse_lowlevel.h"

struct fuse_chan *fuse_mount(const char *mountpoint, struct fuse_args *args)
{
    struct fuse_chan *ch;
    int fd;

#ifdef __SOLARIS__
    /*
     * Make sure file descriptors 0, 1 and 2 are open, otherwise chaos
     * would ensue.
     */
    do {
        fd = open("/dev/null", O_RDWR);
        if (fd > 2)
            close(fd);
    } while (fd >= 0 && fd <= 2);
#endif /* __SOLARIS__ */

    fd = fuse_kern_mount(mountpoint, args);
    if (fd == -1)
        return NULL;

    ch = fuse_kern_chan_new(fd);
    if (!ch)
        fuse_kern_unmount(mountpoint, fd);

    return ch;
}

void fuse_unmount(const char *mountpoint, struct fuse_chan *ch)
{
    int fd = ch ? fuse_chan_fd(ch) : -1;
    fuse_kern_unmount(mountpoint, fd);
    fuse_chan_destroy(ch);
}

int fuse_version(void)
{
    return FUSE_VERSION;
}

#ifdef __SOLARIS__
#undef fuse_main
int fuse_main(void);
int fuse_main(void)
{
    fprintf(stderr, "fuse_main(): This function does not exist\n");
    return -1;
}
#endif /* __SOLARIS__ */

#ifdef __ANDROID__
int fuse_daemonize(int foreground)
{
    if (!foreground) {
        int nullfd;
        int pid = fork();

        /*
         * demonize current process by forking it and killing the
         * parent.  This makes current process as a child of 'init'.
         */
        if (pid < 0) {
            fprintf(stderr, "fuse_daemonize: fork\n");
            return -1;
        } else if (pid > 0)
            _exit(0);

        if (setsid() == -1) {
            fprintf(stderr, "fuse_daemonize: setsid\n");
            return -1;
        }

        chdir("/");
        nullfd = open("/dev/null", O_RDWR, 0);
        if (nullfd != -1) {
            dup2(nullfd, 0);
            dup2(nullfd, 1);
            dup2(nullfd, 2);
            if (nullfd > 2)
                close(nullfd);
        }
    }
    return 0;
}
#endif
