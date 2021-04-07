# line_buffered_tee

This solves the problem of `tee`ing output from programs that do not flush their output line-by-line. This can cause problems when, for example, you want to append logs lines from multiple concurrent processes to a single log file via `tee`. Unless *all* those programs flush their output line-by-line, you might get mangled logs in your log file.

The [`tee-break`](https://github.com/christianscott/tee-break) repo is a practical demonstration of this problem. Using this program is equivalent to using `your_program | ./bin/line_buffer | tee file1 file2`.

## usage

Once `line_buffered_tee` is on your path, you can simply use it as you would `tee`:

```sh
$ some_noisy_program | line_buffered_tee first_file second_file
I am the first line of logs
I am the second line of logs
```

## installing from source

Build the executable by cloning the repo & running `make all`. The resulting binary can be found at `./bin/line_buffered_tee`.

You can then stick this binary in your path, for example by copying the binary to `/usr/local/bin`:

```sh
$ cp bin/line_buffered_tee /usr/local/bin/line_buffered_tee
```
