const std = @import("std");
const tbc = @cImport(@cInclude("3bc_header.h"));

// zig fmt: off
const prog = [_]tbc.tbc_u8_t{
    tbc.MODE, tbc.NILL, tbc.TBC_MODE_STRING,
    tbc.STRC, tbc.NILL, 'H',
    tbc.STRC, tbc.NILL, 'E',
    tbc.STRC, tbc.NILL, 'L',
    tbc.STRC, tbc.NILL, 'L',
    tbc.STRC, tbc.NILL, 'O',
    tbc.STRC, tbc.NILL, '!',
    tbc.STRC, tbc.NILL, '\n'
};
// zig fmt: on

pub fn main() !void {
    const instance = struct {
        var static: tbc.app_3bc_s = undefined;
    };
    instance.static.cin.tty_storage.io.arr.ptr = @constCast(@ptrCast(&prog));
    instance.static.stack.cfgmin.prog_size = prog.len;
    while (tbc.driver_interrupt(&instance.static)) {
        continue;
    }
}
