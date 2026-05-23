SRC_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
BUILD  ?= $(shell pwd)
CC     ?= gcc
CFLAGS ?= -O2
CPPFLAGS ?=
INSTALL ?= install

all: $(BUILD)/libinotify.so

$(BUILD)/libinotify.so: $(SRC_DIR)/inotify.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -fPIC -shared -Wall \
		-I"$(SRC_DIR)/include" \
		"$(SRC_DIR)/inotify.c" \
		-o $(BUILD)/libinotify.so

install: all
	$(INSTALL) -d "$(DESTDIR)/include/inotify/sys"
	$(INSTALL) -d "$(DESTDIR)/include/inotify/bits"
	$(INSTALL) -d "$(DESTDIR)/lib"
	$(INSTALL) "$(SRC_DIR)/include/sys/inotify.h"  "$(DESTDIR)/include/inotify/sys/inotify.h"
	$(INSTALL) "$(SRC_DIR)/include/bits/inotify.h" "$(DESTDIR)/include/inotify/bits/inotify.h"
	$(INSTALL) $(BUILD)/libinotify.so "$(DESTDIR)/lib/libinotify.so"
