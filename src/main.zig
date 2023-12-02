const std = @import("std");

const day1 = @import("./day1.zig");

pub fn main() !void {
    std.debug.print("day1_p1: {d}\n", .{day1.p1()}); // 54940
    std.debug.print("day1_p2: {d}\n", .{day1.p2()}); // 54208
}
