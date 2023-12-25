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

        const winning_nums_str = parts.next() orelse return error.InvalidFormat;
        const winning_nums = blk: {
            var result: [32]i32 = undefined;
            var result_count: usize = 0;
            var tokens = std.mem.tokenizeScalar(u8, winning_nums_str, ' ');

            while (tokens.next()) |num_str| : (result_count += 1) {
                result[result_count] = try std.fmt.parseInt(i32, num_str, 10);
            }
            break :blk result[0..result_count];
        };

        const card_nums_str = parts.next() orelse return error.InvalidFormat;
        const points = blk: {
            var result: i32 = 0;
            var tokens = std.mem.tokenizeScalar(u8, card_nums_str, ' ');

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

pub fn p2() !i32 {
    const data = @embedFile("data/day4.txt");

    var line_it = std.mem.splitScalar(u8, data, '\n');
    var matching_nums_buffer: [256]usize = undefined;
    var cards_count: usize = 0;

    while (line_it.next()) |line| : (cards_count += 1) {
        var parts = std.mem.splitSequence(u8, line, ": ");
        _ = parts.next() orelse return error.InvalidFormat; // skip over the card name
        parts = std.mem.splitSequence(u8, parts.next() orelse return error.InvalidFormat, " | ");

        const winning_nums_str = parts.next() orelse return error.InvalidFormat;
        const winning_nums = blk: {
            var result: [16]i32 = undefined;
            var nums_count: usize = 0;
            var tokens = std.mem.tokenizeScalar(u8, winning_nums_str, ' ');

            while (tokens.next()) |num_str| : (nums_count += 1) {
                const num = try std.fmt.parseInt(u8, num_str, 10);
                result[nums_count] = num;
            }
            break :blk result[0..nums_count];
        };

        const nums_str = parts.next() orelse return error.InvalidFormat;
        const matching_count = blk: {
            var result: usize = 0;
            var tokens = std.mem.tokenizeScalar(u8, nums_str, ' ');

            while (tokens.next()) |num_str| {
                const num = try std.fmt.parseInt(u8, num_str, 10);
                if (std.mem.indexOfScalar(i32, winning_nums, num) != null) {
                    result += 1;
                }
            }
            break :blk result;
        };

        matching_nums_buffer[cards_count] = matching_count;
    }

    const matching_nums = matching_nums_buffer[0..cards_count];

    var card_counts = blk: {
        var buffer: [256]i32 = undefined;
        for (0..cards_count) |i| {
            buffer[i] = 1;
        }
        break :blk buffer[0..cards_count];
    };

    for (matching_nums, 0..) |match_count, i| {
        const card_count = card_counts[i];

        const from = @min(i + 1, matching_nums.len);
        const to = @min(i + 1 + match_count, matching_nums.len);

        for (from..to) |j| {
            card_counts[j] += card_count;
        }
    }

    var total_cards: i32 = 0;
    for (card_counts) |count| {
        total_cards += count;
    }
    return total_cards;
}
