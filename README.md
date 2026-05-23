# inotify-stub

This implements inotify shim by creating a valid FD at `inotify_init`. The FD is doing nothing but valid for queueing for many POSIX calls.

## Building

```sh
make install
```

## Using the library

```sh
CFLAGS+=" -I/usr/include/inotify"
LDFLAGS+=" -linotify"
```

## License

MIT. The `include` dir is LGPL belongs to GNU C Library.
