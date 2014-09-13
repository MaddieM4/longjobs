.PHONY: all

out ?= /usr/

all:
	@echo "It's just a script. Nothing to build."

install:
	mkdir -p $(out)/bin/
	cp longjobs $(out)/bin/
	cp i3status_prepend $(out)/bin/i3status_prepend_longjobs
