# googletest

This is [googletest](https://github.com/google/googletest), packaged for
[Zig](https://ziglang.org/).

## How to use it

First, update your `build.zig.zon`:

```
zig fetch --save git+https://github.com/allyourcodebase/googletest
```

Next, in `build.zig`, declare the dependency and link your test with the static libraries:

```zig
const googletest_dep = b.dependency("googletest", .{
    .target = target,
    .optimize = optimize,
});

const tests_exe = b.addExecutable(.{
    .name = "tests",
    .root_module = b.createModule(.{ .target = target, .optimize = optimize }),
});
tests_exe.addCSourceFiles(.{ .files = &.{"src/tests.cpp"} }); // your test files
tests_exe.linkLibrary(googletest_dep.artifact("gtest"));
// Unless you define your own entry point, you need `gtest_main` too.
tests_exe.linkLibrary(googletest_dep.artifact("gtest_main"));
```
