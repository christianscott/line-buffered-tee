#include <stdio.h>
#include <stdlib.h>

#define EPRINTF(...) fprintf(stderr, __VA_ARGS__)

#ifdef IS_DEBUG
#define DEBUG(...) EPRINTF(__VA_ARGS__)
#else
#define DEBUG(...)
#endif // IS_DEBUG

#define WRITE_AND_FLUSH(fptr, buf, size, n) \
    do {                                    \
        fwrite(buf, size, n, fptr);         \
        fflush(fptr);                       \
    } while (0)

#define WRITE_AND_FLUSH_TO_EACH(fptrs, n_fptrs, buf, size, n) \
    for (int WRITE_AND_FLUSH_TO_EACH_i = 0; WRITE_AND_FLUSH_TO_EACH_i < n_fptrs; WRITE_AND_FLUSH_TO_EACH_i++) { \
        WRITE_AND_FLUSH(fptrs[WRITE_AND_FLUSH_TO_EACH_i], buf, size, n); \
    }

#define INITIAL_CAP 1024

int main(int argc, char **argv)
{
    if (argc != 2) {
        EPRINTF("expected at least one file to write to\n");
        exit(1);
    }

    int n_descriptors = argc - 1;
    FILE **descriptors = malloc(sizeof(FILE*) * n_descriptors);
    descriptors[0] = stdout;
    for (int i = 1; i < argc; i++) {
        DEBUG("attempting to open %s\n", argv[i]);
        FILE *file = fopen(argv[i], "a");
        if (file == NULL) {
            EPRINTF("failed to open file %s\n", argv[i]);
            exit(1);
        }
        descriptors[i] = file;
    }

    size_t cap = INITIAL_CAP;
    size_t n = 0;
    char *buf = malloc(sizeof(char) * cap);

    while (1) {
        if (n == cap) {
            cap *= 2;
            char *buf_new = realloc(buf, sizeof(char) * cap);
            if (buf_new == NULL) {
                EPRINTF("could not reallocate buffer (from size %lu to %lu)\n", cap / 2, cap);
                exit(1);
            }
            buf = buf_new;
        }

        char c = fgetc(stdin);
        if (feof(stdin)) {
            DEBUG("hit the end of the input\n");
            break;
        }

        buf[n++] = c;
        if (c == '\n') {
            DEBUG("hit a newline, flushing buffered input to outputs\n");
            WRITE_AND_FLUSH_TO_EACH(descriptors, n_descriptors, buf, sizeof(char), n);
            n = 0;
        }
    }

    if (n > 0) {
        DEBUG("writing %lu remaining bytes to outputs\n", n);
        // there are remaining bytes to write to the outputs
        buf[n++] = '\n';
        WRITE_AND_FLUSH_TO_EACH(descriptors, n_descriptors, buf, sizeof(char), n);
    }

    return 0;
}
