const std = @import("std");

pub fn p1() i32 {
    var data = @embedFile("data/day1.txt");
    var sum: i32 = 0;
    var line_it = std.mem.tokenize(u8, data, "\n");

    while (line_it.next()) |line| {
        for (0..line.len) |i| {
            if (std.ascii.isDigit(line[i])) {
                sum += (line[i] - '0') * 10;
                break;
            }
        }

        for (0..line.len) |i| {
            var j = line.len - 1 - i;
            if (std.ascii.isDigit(line[j])) {
                sum += (line[j] - '0');
                break;
            }
        }
    }

    return sum;
}

pub fn p2() i32 {
    var data = @embedFile("data/day1.txt");
    var sum: usize = 0;
    var line_it = std.mem.tokenize(u8, data, "\n");

    const digits = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

    while (line_it.next()) |line| {
        var first_digit: usize = 0;
        var first_digit_pos: usize = std.math.maxInt(usize);

        var last_digit: usize = 0;
        var last_digit_pos: usize = 0;

        // search for digit chars
        for (0..line.len) |i| {
            if (std.ascii.isDigit(line[i])) {
                first_digit = line[i] - '0';
                first_digit_pos = i;
                break;
            }
        }

        for (0..line.len) |i| {
            var j = line.len - 1 - i;
            if (std.ascii.isDigit(line[j])) {
                last_digit = line[j] - '0';
                last_digit_pos = j;
                break;
            }
        }

        // search for digit strings
        for (digits, 0..) |digit, i| {
            if (std.mem.indexOf(u8, line, digit)) |pos| {
                if (pos < first_digit_pos) {
                    first_digit = i + 1;
                    first_digit_pos = pos;
                }
            }

            if (std.mem.lastIndexOf(u8, line, digit)) |pos| {
                if (pos > last_digit_pos) {
                    last_digit = i + 1;
                    last_digit_pos = pos;
                }
            }
        }

        sum += first_digit * 10;
        sum += last_digit;
    }

    return @intCast(sum);
}
