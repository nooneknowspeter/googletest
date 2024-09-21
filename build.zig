const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const googletest_dep = b.dependency("googletest", .{});

    const gtest = b.addStaticLibrary(.{
        .name = "gtest",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    gtest.linkLibCpp();
    gtest.addCSourceFile(.{
        .file = googletest_dep.path("googletest/src/gtest-all.cc"),
        .flags = &.{},
    });
    gtest.addIncludePath(googletest_dep.path("googletest/include"));
    gtest.addIncludePath(googletest_dep.path("googletest"));
    gtest.installHeadersDirectory(googletest_dep.path("googletest/include"), ".", .{});

    b.installArtifact(gtest);

    const gtest_main = b.addStaticLibrary(.{
        .name = "gtest_main",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    gtest_main.linkLibCpp();
    gtest_main.addCSourceFile(.{
        .file = googletest_dep.path("googletest/src/gtest_main.cc"),
        .flags = &.{},
    });
    gtest_main.addIncludePath(googletest_dep.path("googletest/include"));
    gtest_main.addIncludePath(googletest_dep.path("googletest"));
    gtest_main.installHeadersDirectory(googletest_dep.path("googletest/include"), ".", .{});
    b.installArtifact(gtest_main);
}
