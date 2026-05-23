SRC_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

CC     ?= gcc
CFLAGS ?= -O2
CPPFLAGS ?=

all: libinotify.so

libinotify.so: $(SRC_DIR)/inotify.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -fPIC -shared -Wall \
		-I"$(SRC_DIR)/include" \
		"$(SRC_DIR)/inotify.c" \
		-o libinotify.so

install: all
	install "$(SRC_DIR)/include/sys/inotify.h"  "$(DESTDIR)/usr/include/inotify/sys/inotify.h"
	install "$(SRC_DIR)/include/bits/inotify.h" "$(DESTDIR)/usr/include/inotify/bits/inotify.h"
	install libinotify.so "$(DESTDIR)/usr/lib/libinotify.so"
