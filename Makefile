OUTDIR=bin

.PHONY: all setup clean

setup:
	@mkdir -p $(OUTDIR)

clean:
	@rm -rf $(OUTDIR)

executable: setup line_buffered_tee.c
	@gcc $(DEBUG) -o $(OUTDIR)/line_buffered_tee line_buffered_tee.c

tee-breaker: setup example/tee_breaker.c
	@gcc -o $(OUTDIR)/tee_breaker example/tee_breaker.c

example: tee-breaker executable
	./example/run.sh

debug: DEBUG=-DIS_DEBUG -g
debug: executable

all: setup executable
