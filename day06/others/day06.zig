const std = @import("std");
const print = std.debug.print;

fn is_matcher(input: []const u8, k: usize) bool {
    var freq: [26]u8 = [_]u8{0} ** 26;
    for (input) |c| {
        const idx = c - 'a';
        freq[idx] += 1;
    }
    var count: usize = 0;
    for (freq) |f| {
        if (f > 0) count += 1;
    }
    return count == k;
}

fn lookup(input: []const u8, k: usize) i32 {
    var left: usize = 0;
    var right: usize = 0;
    while (right < input.len) {
        right += 1;
        if (is_matcher(input[left..right], k)) {
            return @intCast(i32, right);
        }
        if (right - left >= k) {
            left += 1;
        }
    }
    return -1;
}

pub fn main() void {
    const input = @embedFile("../input.txt");
    print("Part 1 = {}\n", .{lookup(input, 4)});
    print("Part 2 = {}\n", .{lookup(input, 14)});
}
