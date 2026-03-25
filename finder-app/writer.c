#include "stdio.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <syslog.h>

int main(int argc, char *argv[]) {
    openlog(NULL, 0, LOG_USER);

    if (argc != 3) {
        syslog(LOG_ERR, "Invalid number of arguments: %d", argc);
        return 1;
    }
    if (argv[1] == NULL || argv[2] == NULL) { 
        syslog(LOG_ERR, "Invalid input parameters");
        return 1;
    }

    char *filename = argv[1]; /* pass filename */

    /* Open/Create file */
    int fd = open(filename,
        O_WRONLY | O_CREAT | O_TRUNC, /* flags */
        S_IWUSR | S_IRUSR | S_IWGRP | S_IROTH /* chmode*/
    );  
    if (fd == -1) {
        syslog(LOG_ERR, "Error while opening file: %s", strerror(errno));
        return 1;
    }
    
    /* write to the file */
    char *writestr = argv[2];
    ssize_t num_bytes;
    
    if (write(fd, writestr, strlen(writestr)) != -1) {
        syslog(LOG_DEBUG, "Writing %s to %s", writestr, filename);
    }
    else {
        syslog(LOG_ERR, "Error while writing to the file: %s", strerror(errno));
        return 1;
    }

    /* close the file */
    if (close (fd) == -1) {
        syslog(LOG_ERR, "Error while closing the file: %s", strerror(errno));
        return 1;
    }
 
    return 0;
}
