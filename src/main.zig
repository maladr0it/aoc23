const std = @import("std");

const day1 = @import("./day1.zig");
const day2 = @import("./day2.zig");
const day3 = @import("./day3.zig");

pub fn main() !void {
    std.debug.print("day1_p1: {!}\n", .{day1.p1()}); // 54940
    std.debug.print("day1_p2: {!}\n", .{day1.p2()}); // 54208
    std.debug.print("day2_p1: {!}\n", .{day2.p1()}); // 2268
    std.debug.print("day2_p2: {!}\n", .{day2.p2()}); // 63542
    std.debug.print("day3_p1: {!}\n", .{day3.p1()}); // 527144
    std.debug.print("day3_p2: {!}\n", .{day3.p2()}); // 81463996
}
