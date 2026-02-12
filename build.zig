const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const gtest_dep = b.dependency("googletest", .{});

    const gtest = b.addLibrary(.{
        .name = "gtest",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    gtest.linkLibCpp();
    gtest.root_module.addCSourceFile(.{
        .file = gtest_dep.path("googletest/src/gtest-all.cc"),
        .flags = &.{"-std=c++17"},
    });
    gtest.root_module.addIncludePath(gtest_dep.path("googletest/include"));
    gtest.root_module.addIncludePath(gtest_dep.path("googletest"));
    gtest.installHeadersDirectory(gtest_dep.path("googletest/include"), ".", .{});
    b.installArtifact(gtest);

    const gtest_main = b.addLibrary(.{
        .name = "gtest_main",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    gtest_main.linkLibCpp();
    gtest_main.root_module.addCSourceFile(.{
        .file = gtest_dep.path("googletest/src/gtest_main.cc"),
        .flags = &.{"-std=c++17"},
    });
    gtest_main.root_module.addIncludePath(gtest_dep.path("googletest/include"));
    gtest_main.root_module.addIncludePath(gtest_dep.path("googletest"));
    gtest_main.installHeadersDirectory(gtest_dep.path("googletest/include"), ".", .{});
    b.installArtifact(gtest_main);

    const gmock = b.addLibrary(.{
        .name = "gmock",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    gmock.root_module.addCSourceFile(.{
        .file = gtest_dep.path("googlemock/src/gmock-all.cc"),
        .flags = &.{"-std=c++17"},
    });
    gmock.linkLibCpp();
    gmock.addIncludePath(gtest_dep.path("googlemock/include"));
    gmock.addIncludePath(gtest_dep.path("googlemock"));
    gmock.installHeadersDirectory(gtest_dep.path("googlemock/include"), ".", .{});
    gmock.linkLibrary(gtest);
    b.installArtifact(gmock);

    const samples_exe = b.addExecutable(.{
        .name = "gtest_samples",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    samples_exe.addCSourceFiles(.{
        .root = gtest_dep.path("googletest/samples"),
        .files = &.{
            "sample1_unittest.cc",
            "sample1.cc",
            "sample2_unittest.cc",
            "sample2.cc",
            "sample3_unittest.cc",
            "sample4_unittest.cc",
            "sample4.cc",
            "sample5_unittest.cc",
            "sample6_unittest.cc",
            "sample7_unittest.cc",
            "sample8_unittest.cc",
        },
    });
    samples_exe.linkLibrary(gtest);
    samples_exe.linkLibrary(gtest_main);
    b.installArtifact(samples_exe);

    // Samples 9 and 10 define their own entrypoint.
    const sample9_exe = b.addExecutable(.{
        .name = "gtest_sample9",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    sample9_exe.addCSourceFiles(.{
        .root = gtest_dep.path("googletest/samples"),
        .files = &.{
            "sample9_unittest.cc",
        },
    });
    sample9_exe.linkLibrary(gtest);
    b.installArtifact(sample9_exe);

    const sample10_exe = b.addExecutable(.{
        .name = "gtest_sample10",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    sample10_exe.addCSourceFiles(.{
        .root = gtest_dep.path("googletest/samples"),
        .files = &.{"sample10_unittest.cc"},
    });
    sample10_exe.linkLibrary(gtest);
    b.installArtifact(sample10_exe);

    const samples_step = b.step("samples", "Build the sample tests");
    samples_step.dependOn(&samples_exe.step);
    samples_step.dependOn(&sample9_exe.step);
    samples_step.dependOn(&sample10_exe.step);
    samples_step.dependOn(b.getInstallStep());
}
