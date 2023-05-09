# Issue #2227 Reproducer

https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues/2227

Run as follows:

```
swift run Run analyze --limit 5
```

Example output:

```
❯ swift run Run analyze --limit 5
Building for debugging...
[3/3] Linking Run
Build complete! (1.80s)
[ INFO ] using transaction: false
sleeping
sleeping
sleeping
sleeping
sleeping
[ INFO ] Task 4 done
[ INFO ] Task 0 done
[ INFO ] Task 2 done
[ INFO ] Task 1 done
[ INFO ] Task 3 done
[ INFO ] done.
~/D/debug-2227 on repro took 14s
❯ swift run Run analyze --limit 5 -t
Building for debugging...
Build complete! (0.28s)
[ INFO ] using transaction: true
sleeping
[ ERROR ] Connection request timed out. This might indicate a connection deadlock in your application. If you're running long running requests, consider increasing your connection timeout. [database-id: psql]
[ ERROR ] Connection request timed out. This might indicate a connection deadlock in your application. If you're running long running requests, consider increasing your connection timeout. [database-id: psql]
[ ERROR ] Connection request timed out. This might indicate a connection deadlock in your application. If you're running long running requests, consider increasing your connection timeout. [database-id: psql]
[ ERROR ] Connection request timed out. This might indicate a connection deadlock in your application. If you're running long running requests, consider increasing your connection timeout. [database-id: psql]
[ ERROR ] The operation couldn’t be completed. (AsyncKit.ConnectionPoolTimeoutError error 0.)
[ INFO ] done.
```
