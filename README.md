# libsegfault -- get a nice stacktrace when your application crashes

## What

A preloadable library that will print a stacktrace of the program when it crashes
(and received SEGV), or upon receiving any other relevant signal.

## Why

A lot of times the application resident memory size is so big that collecting
core dumps is inpracticle.  However being able to see the crash stacktrace is
desirable.  Without a stacktrace figuring our the reason of the crash might
be very hard if not impossible.

## How

Just link your program again libsegfault.  Or use LD_PRELOAD, e.g.
```shell
% env LD_PRELOAD=/path/to/libsegfault.so ./app
```

## Building

* Install libunwind: pkg install libunwind
* make && make install

## Testing

After starting your program with libsegfault preloaded or linked in
send the SEGV signal to the program.  You should see a stacktrace
printed into the stderror.
```shell
% env LD_PRELOAD=/path/to/libsegfault.so ./app
% kill -SEGV ${PID}
```

You should see something along the lines of:

    Caught signal 11 (SEGV) in program sleep [27759]
    
      thread frame     IP       function
      [100689]  0: 0x800afbe0a: __sys_nanosleep()+0xa
      [100689]  1: 0x80120ebcc: _pthread_suspend_all_np()+0x10dc
      [100689]  2: 0x000400a38: <unknown>
      [100689]  3: 0x00040086f: <unknown>
      [100689]  4: 0x800620000: <unknown>
    
    Backtrace: 0x800afbe0a 0x80120ebcc 0x400a38 0x40086f 0x800620000
    Segmentation fault (core dumped)

## Configuration

libsegfaults looks at the *SEGFAULT_SIGNALS* environment variable
on startup. If that variable is not set, only SIGSEGV handler is
enabled.  If it's set to "all", libsegfault will intercept all
the signals that usually result in a crash: SIGSEGV, SIGBUS, SIGILL, SIGABRT, SIGFPE and SIGSYS.
Optionally, the variable can also be set to a custom list of space
separated signals.

For example the following command will tell /libsegfault/ to intercept
only SEGV and SIGILL (illegal instruction) conditions:
```shell
% env SEGFAULT_SIGNALS="SEGV ILL" LD_PRELOAD=/path/to/libsegfault.so ./app
```

To intercept all signals, user
```shell
% env SEGFAULT_SIGNALS=all LD_PRELOAD=/path/to/libsegfault.so ./app
```
