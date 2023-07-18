const std = @import("std");
const GitRepoStep = @import("GitRepoStep.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libdep = libHello(b, .{
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "hello-zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    for (libdep.include_dirs.items) |dir| {
        exe.include_dirs.append(dir) catch {};
    }
    exe.linkLibrary(libdep);
    exe.linkLibC();

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

fn libHello(b: *std.Build, properties: BuildProperties) *std.Build.Step.Compile {
    const repo = GitRepoStep.create(b, .{
        .url = "https://github.com/RodrigoDornelles/3bc-lang.git",
        .branch = "develop-wip-wip",
        .sha = "9464896bec714c73132ce077ac9169ed1964b05e",
        .fetch_enabled = true,
    });

    const lib = b.addStaticLibrary(.{
        .name = "3bc_hello",
        .target = properties.target,
        .optimize = properties.optimize,
    });
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/alu" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/cpu" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/driver" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/bus" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/sys" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/util" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/interpreter" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/types" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/legacy" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/i18n" }));
    lib.addIncludePath(b.pathJoin(&.{ repo.path, "src/ds" }));
    lib.addCSourceFiles(&.{
        "dep/3bc-lang.git/src/alu/alu_none.c",
        "dep/3bc-lang.git/src/bus/bus_cfg_hello.c",
        "dep/3bc-lang.git/src/bus/bus_cpu_hello.c",
        "dep/3bc-lang.git/src/bus/bus_sys_hello.c",
        "dep/3bc-lang.git/src/cpu/cpu_common.c",
        "dep/3bc-lang.git/src/cpu/cpu_string.c",
        "dep/3bc-lang.git/src/driver/driver_cpu.c",
        "dep/3bc-lang.git/src/driver/driver_error.c",
        "dep/3bc-lang.git/src/driver/driver_gc.c",
        "dep/3bc-lang.git/src/driver/driver_interrupt.c",
        "dep/3bc-lang.git/src/driver/driver_stack.c",
        "dep/3bc-lang.git/src/ds/ds_prog_array.c",
        "dep/3bc-lang.git/src/i18n/i18n_no-ne.c",
        "dep/3bc-lang.git/src/interpreter/interpreter_mock.c",
        "dep/3bc-lang.git/src/sys/sys_posix_output.c",
        "dep/3bc-lang.git/src/sys/sys_common_mock.c",
        "dep/3bc-lang.git/src/util/util_itos.c",
    }, &.{
        "-Wall",
        "-Wextra",
        "-Wshadow",
    });
    lib.linkLibC();
    lib.step.dependOn(&repo.step);
    return lib;
}

const src = &.{
    // "dep/3bc-lang.git/src/alu/alu_math.c",
    // "dep/3bc-lang.git/src/bus/bus_cfg_lang.c",
    // "dep/3bc-lang.git/src/bus/bus_cpu_lang.c",
    // "dep/3bc-lang.git/src/bus/bus_sys_lang.c",
    // "dep/3bc-lang.git/src/cpu/cpu_jump.c",
    // "dep/3bc-lang.git/src/cpu/cpu_math.c",
    // "dep/3bc-lang.git/src/cpu/cpu_memory.c",
    // "dep/3bc-lang.git/src/cpu/cpu_procedure.c",
    // "dep/3bc-lang.git/src/cpu/cpu_sleep.c",
    // "dep/3bc-lang.git/src/ds/ds_ram_array.c",
    // "dep/3bc-lang.git/src/i18n/i18n_en-us.c",
    // "dep/3bc-lang.git/src/interpreter/interpreter_parser.c",
    // "dep/3bc-lang.git/src/interpreter/interpreter_readln.c",
    // "dep/3bc-lang.git/src/interpreter/interpreter_syntax.c",
    // "dep/3bc-lang.git/src/interpreter/interpreter_ticket.c",
    // "dep/3bc-lang.git/src/interpreter/interpreter_tokens.c",
    // "dep/3bc-lang.git/src/legacy/driver_accumulator.c",
    // "dep/3bc-lang.git/src/legacy/driver_custom.c",
    // "dep/3bc-lang.git/src/legacy/driver_gpio.c",
    // "dep/3bc-lang.git/src/legacy/driver_idle.c",
    // "dep/3bc-lang.git/src/legacy/driver_mode.c",
    // "dep/3bc-lang.git/src/legacy/driver_power.c",
    // "dep/3bc-lang.git/src/legacy/driver_program.c",
    // "dep/3bc-lang.git/src/legacy/driver_tty.c",
    // "dep/3bc-lang.git/src/legacy/ds_hypervisor_darray.c",
    // "dep/3bc-lang.git/src/legacy/ds_label_hash.c",
    // "dep/3bc-lang.git/src/legacy/ds_memory_llrbt.c",
    // "dep/3bc-lang.git/src/legacy/ds_procedure_lifo.c",
    // "dep/3bc-lang.git/src/legacy/driver_memory.c",
    // "dep/3bc-lang.git/src/legacy/ds_program_fifo.c",
    // "dep/3bc-lang.git/src/sys/sys_common_pexa.c",
    // "dep/3bc-lang.git/src/sys/sys_conio_output.c",
    // "dep/3bc-lang.git/src/sys/sys_nes_output.c",
    // "dep/3bc-lang.git/src/sys/sys_windows_output.c",
    // "dep/3bc-lang.git/src/util/util_djb2.c",
    // "dep/3bc-lang.git/src/util/util_stoi.c",
};

const BuildProperties = struct {
    target: std.zig.CrossTarget,
    optimize: std.builtin.OptimizeMode,
};
