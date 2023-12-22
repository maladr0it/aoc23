// https://adventofcode.com/2023/day/2

const std = @import("std");

pub fn p1() !i32 {
    const max_red = 12;
    const max_green = 13;
    const max_blue = 14;
    const data = @embedFile("data/day2.txt");

    var sum: i32 = 0;
    var game_num: i32 = 1;
    var line_it = std.mem.splitScalar(u8, data, '\n');

    while (line_it.next()) |line| : (game_num += 1) {
        var is_possible = true;

        var parts = std.mem.splitSequence(u8, line, ": ");
        _ = parts.next() orelse return error.InvalidFormat; // skip over the game name
        var draws = std.mem.splitSequence(u8, parts.next() orelse return error.InvalidFormat, "; ");

        while (draws.next()) |draw| {
            var red_count: i32 = 0;
            var green_count: i32 = 0;
            var blue_count: i32 = 0;

            var items = std.mem.splitSequence(u8, draw, ", ");
            while (items.next()) |item| {
                var item_parts = std.mem.splitScalar(u8, item, ' ');
                var count_token = item_parts.next() orelse return error.InvalidFormat;
                var count = try std.fmt.parseInt(i32, count_token, 10);
                var color = item_parts.next() orelse return error.InvalidFormat;

                if (std.mem.eql(u8, color, "red")) {
                    red_count += count;
                } else if (std.mem.eql(u8, color, "green")) {
                    green_count += count;
                } else if (std.mem.eql(u8, color, "blue")) {
                    blue_count += count;
                }
            }

            if (red_count > max_red or green_count > max_green or blue_count > max_blue) {
                is_possible = false;
                break;
            }
        }

        if (is_possible) {
            sum += game_num;
        }
    }

    return sum;
}

pub fn p2() !i32 {
    const data = @embedFile("data/day2.txt");

    var sum: i32 = 0;
    var line_it = std.mem.splitScalar(u8, data, '\n');

    while (line_it.next()) |line| {
        var red_needed: i32 = 0;
        var green_needed: i32 = 0;
        var blue_needed: i32 = 0;

        var parts = std.mem.splitSequence(u8, line, ": ");
        _ = parts.next() orelse return error.InvalidFormat; // skip over the game name
        var draws_token = parts.next() orelse return error.InvalidFormat;
        var draws = std.mem.splitSequence(u8, draws_token, "; ");

        while (draws.next()) |draw| {
            var red_count: i32 = 0;
            var green_count: i32 = 0;
            var blue_count: i32 = 0;
            var items = std.mem.splitSequence(u8, draw, ", ");

            while (items.next()) |item| {
                var item_parts = std.mem.splitScalar(u8, item, ' ');
                var count_token = item_parts.next() orelse return error.InvalidFormat;
                var count = try std.fmt.parseInt(i32, count_token, 10);
                var color = item_parts.next() orelse return error.InvalidFormat;

                if (std.mem.eql(u8, color, "red")) {
                    red_count += count;
                } else if (std.mem.eql(u8, color, "green")) {
                    green_count += count;
                } else if (std.mem.eql(u8, color, "blue")) {
                    blue_count += count;
                }
            }

            red_needed = @max(red_count, red_needed);
            green_needed = @max(green_count, green_needed);
            blue_needed = @max(blue_count, blue_needed);
        }

        sum += red_needed * green_needed * blue_needed;
    }

    return sum;
}
