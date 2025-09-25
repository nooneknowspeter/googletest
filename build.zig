const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const googletest_dep = b.dependency("googletest", .{});

    const gtest = b.addLibrary(.{ .name = "gtest", .root_module = b.createModule(.{ .target = target, .optimize = optimize, .link_libc = true, .link_libcpp = true }) });

    gtest.root_module.addCSourceFile(.{ .file = googletest_dep.path("googletest/src/gtest-all.cc"), .flags = &.{} });
    gtest.root_module.addIncludePath(googletest_dep.path("googletest/include"));
    gtest.root_module.addIncludePath(googletest_dep.path("googletest"));
    gtest.installHeadersDirectory(googletest_dep.path("googletest/include"), ".", .{});

    b.installArtifact(gtest);

    const gtest_main = b.addLibrary(.{ .name = "gtest_main", .root_module = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    }) });

    gtest_main.root_module.addCSourceFile(.{
        .file = googletest_dep.path("googletest/src/gtest_main.cc"),
        .flags = &.{},
    });
    gtest_main.root_module.addIncludePath(googletest_dep.path("googletest/include"));
    gtest_main.root_module.addIncludePath(googletest_dep.path("googletest"));
    gtest_main.installHeadersDirectory(googletest_dep.path("googletest/include"), ".", .{});

    b.installArtifact(gtest_main);
}
