OUTDIR=bin

.PHONY: all setup clean

setup:
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)

executable: setup line_buffered_tee.c
	gcc $(DEBUG) -o $(OUTDIR)/line_buffered_tee line_buffered_tee.c

debug: DEBUG=-DIS_DEBUG -g
debug: executable

all: setup executable
