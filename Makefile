SRC_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
BUILD  ?= $(shell pwd)
CC     ?= gcc
AR     ?= ar
CFLAGS ?= -O2
CPPFLAGS ?=
INSTALL ?= install
SHARED ?= 1

ifeq ($(SHARED),1)
MAYBE_SHARED = $(BUILD)/libinotify.so
MAYBE_STATIC =
else ifeq ($(SHARED),0)
MAYBE_SHARED =
MAYBE_STATIC = $(BUILD)/libinotify.a
else
MAYBE_SHARED = $(BUILD)/libinotify.so
MAYBE_STATIC = $(BUILD)/libinotify.a
endif

all: $(MAYBE_SHARED) $(MAYBE_STATIC)

$(BUILD)/libinotify.so: $(SRC_DIR)/inotify.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -fPIC -shared -Wall \
		-I"$(SRC_DIR)/include" \
		"$(SRC_DIR)/inotify.c" \
		-o $(BUILD)/libinotify.so

$(BUILD)/inotify.o: $(SRC_DIR)/inotify.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -static -Wall \
		-I"$(SRC_DIR)/include" \
		-c "$(SRC_DIR)/inotify.c" \
		-o $(BUILD)/inotify.o

$(BUILD)/libinotify.a: $(BUILD)/inotify.o
	$(AR) rcs "$@" "$<"

install: all
	$(INSTALL) -d "$(DESTDIR)/include/inotify/sys"
	$(INSTALL) -d "$(DESTDIR)/include/inotify/bits"
	$(INSTALL) -d "$(DESTDIR)/lib"
	$(INSTALL) "$(SRC_DIR)/include/sys/inotify.h"  "$(DESTDIR)/include/inotify/sys/inotify.h"
	$(INSTALL) "$(SRC_DIR)/include/bits/inotify.h" "$(DESTDIR)/include/inotify/bits/inotify.h"
ifneq ($(MAYBE_SHARED),)
	$(INSTALL) $(BUILD)/libinotify.so "$(DESTDIR)/lib/libinotify.so"
endif
ifneq ($(MAYBE_STATIC),)
	$(INSTALL) $(BUILD)/libinotify.a "$(DESTDIR)/lib/libinotify.a"
endif
