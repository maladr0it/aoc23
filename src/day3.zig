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

fn get_index(width: usize, coords: struct { usize, usize }) usize {
    const row = coords[0];
    const col = coords[1];
    return row * (width + 1) + col;
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

        const result = check_around: {
            // check the rectangle that includes all surrounding cells
            const coords = get_coords(width, index - num_digits);
            const row = coords[0];
            const col = coords[1];

            const from_row = @max(row, 1) - 1;
            const to_row = @min((row + 1) + 1, height);
            const from_col = @max(col, 1) - 1;
            const to_col = @min((col + num_digits) + 1, width);

            for (from_row..to_row) |r| {
                for (from_col..to_col) |c| {
                    switch (read_coords(map, width, .{ r, c })) {
                        '0'...'9', '.' => {},
                        else => {
                            break :check_around true;
                        },
                    }
                }
            }

            break :check_around false;
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

pub fn p2() !i32 {
    const data = @embedFile("data/day3.txt");
    const width = std.mem.indexOfScalar(u8, data, '\n') orelse data.len;
    const height = 1 + data.len / (width + 1);

    var buffer: [65536]u8 = undefined; // 64k ought to be enough for anybody
    var visited = std.mem.bytesAsSlice(bool, buffer[0 .. height * width]);

    const map = data[0..];
    var sum: i32 = 0;

    // find * chars, then search for adjacent numbers
    var index: usize = 0;
    while (index < map.len) : (index += 1) {
        if (map[index] != '*') {
            continue;
        }

        @memset(visited, false);

        const coords = get_coords(width, index);
        const row = coords[0];
        const col = coords[1];

        // check the neighbours for numbers
        const from_row = @max(row, 1) - 1;
        const to_row = @min((row + 1) + 1, height);
        const from_col = @max(col, 1) - 1;
        const to_col = @min((col + 1) + 1, width);

        var product: i32 = 1;
        var adjacent_nums_count: i32 = 0;

        for (from_row..to_row) |r| {
            for (from_col..to_col) |c| {
                if (visited[r * width + c]) {
                    continue;
                }
                if (!std.ascii.isDigit(read_coords(map, width, .{ r, c }))) {
                    continue;
                }
                visited[r * width + c] = true;

                // find first digit
                var start_col = @max(c, 1) - 1;
                while (true) {
                    if (!std.ascii.isDigit(read_coords(map, width, .{ r, start_col }))) {
                        start_col += 1;
                        break;
                    }

                    visited[r * width + start_col] = true;
                    if (start_col == 0) {
                        break;
                    }
                    start_col -= 1;
                }

                // find last digit
                var end_col = c;
                while (end_col < width) {
                    if (!std.ascii.isDigit(read_coords(map, width, .{ r, end_col }))) {
                        break;
                    }
                    visited[r * width + end_col] = true;
                    end_col += 1;
                }

                adjacent_nums_count += 1;
                const digits = map[get_index(width, .{ r, start_col })..get_index(width, .{ r, end_col })];
                const num = try std.fmt.parseInt(i32, digits, 10);
                product *= num;
            }
        }

        if (adjacent_nums_count == 2) {
            sum += product;
        }
    }

    return sum;
}
