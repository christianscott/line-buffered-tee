# 𝓣 line_buffered_tee

> Warning: this is not production-quality software. It's more of a demo than anything else. Buyer beware!

This solves the problem of `tee`ing output from programs that do not flush their output line-by-line. This can cause problems when, for example, you want to append logs lines from multiple concurrent processes to a single log file via `tee`. Unless *all* those programs flush their output line-by-line, you might get mangled logs in your log file.

For a practical demonstration of the problem that this fixes, run `make example`:

```
$ make example
./example/run.sh
Without line buffering (via tee -a):
{{  ""mmssgg""::  ""hheelllloo!!""  }}

{{  ""mmssgg""::  ""ggooooddbbyyee  ::((""  }}

With line buffering (via bin/line_buffered_tee):
{ "msg": "hello!" }
{ "msg": "hello!" }
{ "msg": "goodbye :(" }
{ "msg": "goodbye :(" }
```

The example script runs two commands concurrently, both of which `tee` to the same file & flush after every single character.

You can see that when we use `tee -a` the output from the two commands is interspersed. If we buffer the output line-by-line instead, the log lines are preserved. You can verify that this is also the case for the output file by inspecting `tee.log`.

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
