// https://adventofcode.com/2023/day/4

const std = @import("std");

pub fn p1() !i32 {
    const data = @embedFile("data/day4.txt");

    var line_it = std.mem.splitScalar(u8, data, '\n');
    var total_points: i32 = 0;

    while (line_it.next()) |line| {
        var parts = std.mem.splitSequence(u8, line, ": ");
        _ = parts.next() orelse return error.InvalidFormat; // skip over the card name
        parts = std.mem.splitSequence(u8, parts.next() orelse return error.InvalidFormat, " | ");

        var winning_nums_str = parts.next() orelse return error.InvalidFormat;
        var winning_nums = blk: {
            var result: [32]i32 = undefined;
            var result_count: usize = 0;
            var tokens = std.mem.tokenizeScalar(u8, winning_nums_str, ' ');

            while (tokens.next()) |num_str| : (result_count += 1) {
                result[result_count] = try std.fmt.parseInt(i32, num_str, 10);
            }
            break :blk result[0..result_count];
        };

        var our_nums_str = parts.next() orelse return error.InvalidFormat;
        var points = blk: {
            var result: i32 = 0;
            var tokens = std.mem.tokenizeScalar(u8, our_nums_str, ' ');

            while (tokens.next()) |num_str| {
                const num = try std.fmt.parseInt(i32, num_str, 10);

                if (std.mem.indexOfScalar(i32, winning_nums, num) != null) {
                    result = @max(1, result * 2);
                }
            }
            break :blk result;
        };

        total_points += points;
    }

    return total_points;
}
