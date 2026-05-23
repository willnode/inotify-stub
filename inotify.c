

#include <stdio.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/inotify.h>

static int g_mock_wd_counter = 100;

int inotify_init1(int flags) {
    int fds[2];
    if (pipe(fds) != 0) {
        return -1;
    }

    fcntl(fds[0], F_SETFD, FD_CLOEXEC);
    fcntl(fds[1], F_SETFD, FD_CLOEXEC);

    if (flags & IN_NONBLOCK) {
        int current_flags = fcntl(fds[0], F_GETFL, 0);
        fcntl(fds[0], F_SETFL, current_flags | O_NONBLOCK);
    }

    return fds[0];
}

int inotify_init(void) {
    return inotify_init1(0);
}

int inotify_add_watch(int fd, const char *path, uint32_t mask) {
    int assigned_wd = g_mock_wd_counter++;
    return assigned_wd; 
}

int inotify_rm_watch(int fd, int32_t wd) {
    return 0; 
}