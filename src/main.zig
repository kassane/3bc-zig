const std = @import("std");
const @"3bc" = @cImport(@cInclude("3bc_header.h"));

// zig fmt: off
const prog = [_]@"3bc".tbc_u8_t{
    @"3bc".MODE, @"3bc".NILL, @"3bc".TBC_MODE_STRING,
    @"3bc".STRC, @"3bc".NILL, 'H',
    @"3bc".STRC, @"3bc".NILL, 'E',
    @"3bc".STRC, @"3bc".NILL, 'L',
    @"3bc".STRC, @"3bc".NILL, 'L',
    @"3bc".STRC, @"3bc".NILL, 'O',
    @"3bc".STRC, @"3bc".NILL, '!',
    @"3bc".STRC, @"3bc".NILL, '\n'
};
// zig fmt: on

pub fn main() !void {
    const instance = struct {
        var static: @"3bc".app_3bc_s = undefined;
    };
    instance.static.cin.tty_storage.io.arr.ptr = @constCast(@ptrCast(&prog));
    instance.static.stack.cfgmin.prog_size = prog.len;
    while (@"3bc".driver_interrupt(&instance.static)) {
        continue;
    }
}
