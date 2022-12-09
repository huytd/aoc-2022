const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Point = struct {
    x: i32,
    y: i32,

    const Self = @This();

    pub fn new() Self {
        return .{ .x = 0, .y = 0 };
    }

    pub fn newXY(x: i32, y: i32) Self {
        return .{ .x = x, .y = y };
    }
};

pub fn syncPosition(head: *Point, tail: *Point) void {
    const dx = head.x - tail.x;
    const dy = head.y - tail.y;
    if (std.math.absCast(dx) > 1 or std.math.absCast(dy) > 1) {
        tail.x += std.math.sign(dx);
        tail.y += std.math.sign(dy);
    }
}

const MOVE_MAP = std.ComptimeStringMap(Point, .{
    .{ "U", Point.newXY(0, 1) },
    .{ "D", Point.newXY(0, -1) },
    .{ "R", Point.newXY(1, 0) },
    .{ "L", Point.newXY(-1, 0) },
});

pub fn solve(allocator: std.mem.Allocator, content: []const u8, comptime ropeLen: usize) !u32 {
    var knots: [ropeLen]Point = .{Point.new()} ** ropeLen;
    var lineIter = std.mem.tokenize(u8, content, "\n");
    var tailTrace = std.AutoHashMap(Point, bool).init(allocator);
    while (lineIter.next()) |line| {
        var cmdIter = std.mem.tokenize(u8, line, " ");
        const direction = MOVE_MAP.get(cmdIter.next().?).?;
        const steps = try std.fmt.parseInt(i32, cmdIter.next().?, 10);
        var count: usize = 0;
        while (count < steps) {
            knots[0].x += direction.x;
            knots[0].y += direction.y;
            var knotId: usize = 1;
            while (knotId < ropeLen) {
                syncPosition(&knots[knotId - 1], &knots[knotId]);
                knotId += 1;
            }
            try tailTrace.put(knots[ropeLen - 1], true);
            count += 1;
        }
    }
    return tailTrace.count();
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const content = @embedFile("input.txt");
    const part1 = try solve(allocator, content, 2);
    const part2 = try solve(allocator, content, 10);
    print("Part 1 = {}\nPart 2 = {}", .{ part1, part2 });
}
