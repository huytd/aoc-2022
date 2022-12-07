const std = @import("std");
const print = std.debug.print;

const CHAR_COUNT = 52;

// NOTE:
// To solve Part 1, we can just use the overlappedChars function to find
// the overlapped characters between the two strings.
// For Part 2, we should use the overlappedCharsMultipleStrings since we
// now have more than 2 strings to check.

pub fn charCode(c: u8) usize {
    if (c >= 97 and c <= 122) {
        return c - 'a';
    } else {
        return c - 'A' + 26;
    }
}

pub fn codeToChar(code: usize) u8 {
    if (code < 26) {
        return 'a' + @intCast(u8, code);
    } else {
        return 'A' + @intCast(u8, code) - 26;
    }
}

pub fn overlappedChars(s1: []const u8, s2: []const u8) [CHAR_COUNT]usize {
    var chars: [CHAR_COUNT]usize = [_]usize{0} ** CHAR_COUNT;
    var freq1: [CHAR_COUNT]usize = [_]usize{0} ** CHAR_COUNT;
    var freq2: [CHAR_COUNT]usize = [_]usize{0} ** CHAR_COUNT;
    for (s1) |_, i| {
        freq1[charCode(s1[i])] += 1;
        freq2[charCode(s2[i])] += 1;
    }
    for (s1) |c| {
        const ch = charCode(c);
        if (freq1[ch] > 0 and freq2[ch] > 0) {
            chars[ch] += 1;
        }
    }
    return chars;
}

pub fn overlappedCharsMultipleStrings(comptime size: usize, strings: [size][]const u8) [CHAR_COUNT]usize {
    var chars: [CHAR_COUNT]usize = [_]usize{0} ** CHAR_COUNT;
    var freqs: [size][CHAR_COUNT]usize = [_][CHAR_COUNT]usize{[_]usize{0} ** CHAR_COUNT} ** size;
    for (strings) |string, i| {
        for (string) |c| {
            freqs[i][charCode(c)] += 1;
        }
    }
    for (strings[0]) |c| {
        const ch = charCode(c);
        var foundCount: usize = 0;
        for (freqs) |freq| {
            if (freq[ch] > 0) foundCount += 1;
        }
        if (foundCount == size) {
            chars[ch] += 1;
        }
    }
    return chars;
}

pub fn readInputFile(allocator: std.mem.Allocator) ![]const u8 {
    const file = try std.fs.cwd().openFile("../input.txt", .{ .read = true });
    defer file.close();
    const stat = try file.stat();
    const fileSize = stat.size;
    return try file.reader().readAllAlloc(allocator, fileSize);
}

pub fn part1() !void {
    const allocator = std.heap.page_allocator;
    const content = try readInputFile(allocator);

    var lines = std.mem.tokenize(u8, content, "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
        const mid = line.len / 2;
        const chars = overlappedCharsMultipleStrings(2, [2][]const u8{ line[0..mid], line[mid..] });
        for (chars) |count, c| {
            if (count > 0) {
                sum += c + 1;
            }
        }
    }
    print("Part 1 = {}\n", .{sum});
}

pub fn part2() !void {
    const allocator = std.heap.page_allocator;
    const content = try readInputFile(allocator);

    var iter = std.mem.tokenize(u8, content, "\n");
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    while (iter.next()) |line| {
        try lines.append(line);
    }

    var sum: usize = 0;

    var i: usize = 0;
    while (i < lines.items.len) : (i += 3) {
        const chars = overlappedCharsMultipleStrings(3, [3][]const u8{ lines.items[i], lines.items[i + 1], lines.items[i + 2] });
        for (chars) |count, c| {
            if (count > 0) {
                sum += c + 1;
            }
        }
    }
    print("Part 2 = {}\n", .{sum});
}

pub fn main() !void {
    try part1();
    try part2();
}
