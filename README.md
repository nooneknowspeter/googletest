# GoogleTest

This is a port of [googletest](https://github.com/google/googletest)
using Zig v0.15.1 as a build system.

## Setup

Fetch and add to `build.zig.zon`:

```sh
zig fetch --save git+https://github.com/nooneknowspeter/googletest
```

Add to `build.zig`:

```zig
const dep_gtest = b.dependency("googletest", .{});

cpplings.root_module.linkLibrary(dep_gtest.artifact("gtest"));
```

Use [compile_flagz](https://github.com/deevus/compile_flagz) to get headers
for clangd, `compile_flags.txt`:

```zig
cflags.addIncludePath(dep_gtest.path("include"));
```
