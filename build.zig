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
        .sha = "c562e9852989784dea1caaa12afe188bc983800d",
        .fetch_enabled = true,
    });

    const lib = b.addStaticLibrary(.{
        .name = "3bc_hello",
        .target = properties.target,
        .optimize = properties.optimize,
    });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/alu" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/cpu" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/driver" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/bus" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/sys" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/util" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/interpreter" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/types" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/legacy" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/i18n" }) });
    lib.addIncludePath(.{ .path = b.pathJoin(&.{ repo.path, "src/ds" }) });
    lib.addCSourceFiles(.{
        .files = &[_][]const u8{
            b.pathJoin(&.{ repo.path, "src/alu/alu_none.c" }),
            b.pathJoin(&.{ repo.path, "src/bus/bus_cfg_hello.c" }),
            b.pathJoin(&.{ repo.path, "src/bus/bus_cpu_hello.c" }),
            b.pathJoin(&.{ repo.path, "src/bus/bus_sys_hello.c" }),
            b.pathJoin(&.{ repo.path, "src/cpu/cpu_common.c" }),
            b.pathJoin(&.{ repo.path, "src/cpu/cpu_string.c" }),
            b.pathJoin(&.{ repo.path, "src/driver/driver_cpu.c" }),
            b.pathJoin(&.{ repo.path, "src/driver/driver_error.c" }),
            b.pathJoin(&.{ repo.path, "src/driver/driver_gc.c" }),
            b.pathJoin(&.{ repo.path, "src/driver/driver_interrupt.c" }),
            b.pathJoin(&.{ repo.path, "src/driver/driver_stack.c" }),
            b.pathJoin(&.{ repo.path, "src/ds/ds_prog_array.c" }),
            b.pathJoin(&.{ repo.path, "src/i18n/i18n_no-ne.c" }),
            b.pathJoin(&.{ repo.path, "src/interpreter/interpreter_mock.c" }),
            b.pathJoin(&.{ repo.path, "src/sys/sys_common_mock.c" }),
            b.pathJoin(&.{ repo.path, "src/util/util_itos.c" }),
            if (lib.target.isWindows())
                b.pathJoin(&.{ repo.path, "src/sys/sys_windows_output.c" })
            else
                b.pathJoin(&.{ repo.path, "src/sys/sys_posix_output.c" }),
        },
        .flags = &.{
            "-Wall",
            "-Wextra",
            "-Weverything",
            "-std=gnu99",
            // "-Werror",
        },
    });
    lib.linkLibC();
    lib.step.dependOn(&repo.step);
    return lib;
}

// const src = &.{
// b.pathJoin(&.{ repo.path, "src/alu/alu_math.c"}),
// b.pathJoin(&.{ repo.path, "src/bus/bus_cfg_lang.c"}),
// b.pathJoin(&.{ repo.path, "src/bus/bus_cpu_lang.c"}),
// b.pathJoin(&.{ repo.path, "src/bus/bus_sys_lang.c"}),
// b.pathJoin(&.{ repo.path, "src/cpu/cpu_jump.c"}),
// b.pathJoin(&.{ repo.path, "src/cpu/cpu_math.c"}),
// b.pathJoin(&.{ repo.path, "src/cpu/cpu_memory.c"}),
// b.pathJoin(&.{ repo.path, "src/cpu/cpu_procedure.c"}),
// b.pathJoin(&.{ repo.path, "src/cpu/cpu_sleep.c"}),
// b.pathJoin(&.{ repo.path, "src/ds/ds_ram_array.c"}),
// b.pathJoin(&.{ repo.path, "src/i18n/i18n_en-us.c"}),
// b.pathJoin(&.{ repo.path, "src/interpreter/interpreter_parser.c"}),
// b.pathJoin(&.{ repo.path, "src/interpreter/interpreter_readln.c"}),
// b.pathJoin(&.{ repo.path, "src/interpreter/interpreter_syntax.c"}),
// b.pathJoin(&.{ repo.path, "src/interpreter/interpreter_ticket.c"}),
// b.pathJoin(&.{ repo.path, "src/interpreter/interpreter_tokens.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_accumulator.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_custom.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_gpio.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_idle.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_mode.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_power.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_program.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_tty.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/ds_hypervisor_darray.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/ds_label_hash.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/ds_memory_llrbt.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/ds_procedure_lifo.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/driver_memory.c"}),
// b.pathJoin(&.{ repo.path, "src/legacy/ds_program_fifo.c"}),
// b.pathJoin(&.{ repo.path, "src/sys/sys_common_pexa.c"}),
// b.pathJoin(&.{ repo.path, "src/sys/sys_conio_output.c"}),
// b.pathJoin(&.{ repo.path, "src/sys/sys_nes_output.c"}),
// b.pathJoin(&.{ repo.path, "src/sys/sys_windows_output.c"}),
// b.pathJoin(&.{ repo.path, "src/util/util_djb2.c"}),
// b.pathJoin(&.{ repo.path, "src/util/util_stoi.c"}),
// };

const BuildProperties = struct {
    target: std.zig.CrossTarget,
    optimize: std.builtin.OptimizeMode,
};
