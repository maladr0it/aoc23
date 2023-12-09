// https://adventofcode.com/2023/day/3

const std = @import("std");

fn get_coords(width: usize, index: usize) struct { usize, usize } {
    const row = index / (width + 1);
    const col = index - row * (width + 1);
    return .{ row, col };
}

fn read_coords(map: []const u8, width: usize, coords: struct { usize, usize }) u8 {
    const row = coords[0];
    const col = coords[1];
    return map[row * (width + 1) + col];
}

pub fn p1() !i32 {
    const data = @embedFile("data/day3.txt");
    const width = std.mem.indexOfScalar(u8, data, '\n') orelse data.len;
    const height = 1 + data.len / (width + 1);

    var sum: i32 = 0;
    const map = data[0..];

    var index: usize = 0;
    while (index < map.len) : (index += 1) {
        var num_digits: usize = 0;
        while (std.ascii.isDigit(map[index])) {
            num_digits += 1;
            index += 1;
        }

        if (num_digits == 0) {
            continue;
        }

        // we have found a number, read the surrounding cells
        const result = check_adjacent: {
            const coords = get_coords(width, index - num_digits);
            const row = coords[0];
            const col = coords[1];

            const from_col = @max(col, 1) - 1;
            const to_col = @min(col + num_digits + 1, width);

            // check above
            if (row >= 1) {
                const r = row - 1;
                for (from_col..to_col) |c| {
                    const val = read_coords(map, width, .{ r, c });
                    if (val != '.') {
                        break :check_adjacent true;
                    }
                }
            }

            // check below
            if (row + 1 < height) {
                const r = row + 1;
                for (from_col..to_col) |c| {
                    const val = read_coords(map, width, .{ r, c });
                    if (val != '.') {
                        break :check_adjacent true;
                    }
                }
            }

            // check left
            if (col >= 1) {
                const r = row;
                const c = col - 1;
                const val = read_coords(map, width, .{ r, c });
                if (val != '.') {
                    break :check_adjacent true;
                }
            }

            // check right
            if (col + num_digits < width) {
                const r = row;
                const c = col + num_digits;

                const val = read_coords(map, width, .{ r, c });
                if (val != '.') {
                    break :check_adjacent true;
                }
            }

            break :check_adjacent false;
        };

        if (!result) {
            continue;
        }

        const digits = data[index - num_digits .. index];
        const num = try std.fmt.parseInt(i32, digits, 10);
        sum += num;
    }

    return @intCast(sum);
}

fn p2() i32 {
    const data = @embedFile("data/day3.txt");
    const width = std.mem.indexOfScalar(u8, data, '\n') orelse data.len;
    const height = 1 + data.len / (width + 1);
    _ = height;

    const map = data[0..];

    // find * chars, then search for adjacent numbers

    var index: usize = 0;
    while (index < map.len) : (index += 1) {
        if (map[index] != '*') {
            continue;
        }
    }

    return 0;
}
