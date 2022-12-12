const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Operator = enum { Add, Sub, Mul, Div, Noop };

const OperatorMap = std.ComptimeStringMap(Operator, .{
    .{ "+", .Add },
    .{ "-", .Sub },
    .{ "*", .Mul },
    .{ "/", .Div },
    .{ " ", .Noop },
});

const Monkey = struct {
    items: [1024]i32,
    itemLen: usize,
    operator: Operator,
    operand: []const u8,
    divBy: i32,
    yes: i32,
    no: i32,
    inspectCount: i32,

    pub fn new() Monkey {
        return Monkey{
            .items = [_]i32{0} ** 1024,
            .itemLen = 0,
            .operator = .Noop,
            .operand = "",
            .divBy = 0,
            .yes = 0,
            .no = 0,
            .inspectCount = 0,
        };
    }

    pub fn calc(self: Monkey, input: i32) i32 {
        const operand = std.fmt.parseInt(i32, self.operand, 10) catch input;
        return switch (self.operator) {
            .Add => return input + operand,
            .Sub => return input - operand,
            .Div => return @divFloor(input, operand),
            .Mul => return input * operand,
            .Noop => unreachable,
        };
    }

    pub fn takeFirstItem(self: *Monkey) i32 {
        const item = self.items[0];
        var i: usize = 0;
        while (i < self.itemLen - 1) {
            self.items[i] = self.items[i + 1];
            i += 1;
        }
        self.itemLen -= 1;
        return item;
    }

    pub fn receive(self: *Monkey, item: i32) void {
        self.items[self.itemLen] = item;
        self.itemLen += 1;
    }
};

pub fn makeInput(allocator: std.mem.Allocator, comptime fileName: []const u8) !ArrayList(Monkey) {
    const content = @embedFile(fileName);
    var result = ArrayList(Monkey).init(allocator);
    var lineIter = std.mem.tokenize(u8, content, "\n");
    var currentMonkey: Monkey = undefined;
    while (lineIter.next()) |line| {
        const currentLine = std.mem.trim(u8, line, " ");
        if (std.mem.startsWith(u8, currentLine, "Monkey")) {
            currentMonkey = Monkey.new();
            const startingItemsLine = std.mem.trim(u8, lineIter.next().?, " ");
            var itemsIter = std.mem.tokenize(u8, startingItemsLine["Starting items: ".len..], ",");
            while (itemsIter.next()) |item| {
                const it = try std.fmt.parseInt(i32, std.mem.trim(u8, item, " "), 10);
                currentMonkey.items[currentMonkey.itemLen] = it;
                currentMonkey.itemLen += 1;
            }
            const operationLine = std.mem.trim(u8, lineIter.next().?, " ");
            var operatorIter = std.mem.tokenize(u8, operationLine["Operation: new = old ".len..], " ");
            const operator = operatorIter.next().?;
            const operand = operatorIter.next().?;
            currentMonkey.operator = OperatorMap.get(operator).?;
            currentMonkey.operand = operand;
            const divByLine = std.mem.trim(u8, lineIter.next().?, " ");
            currentMonkey.divBy = try std.fmt.parseInt(i32, divByLine["Test: divisible by ".len..], 10);
            const yesLine = std.mem.trim(u8, lineIter.next().?, " ");
            currentMonkey.yes = try std.fmt.parseInt(i32, yesLine["If true: throw to monkey ".len..], 10);
            const noLine = std.mem.trim(u8, lineIter.next().?, " ");
            currentMonkey.no = try std.fmt.parseInt(i32, noLine["If false: throw to monkey ".len..], 10);
        }
        try result.append(currentMonkey);
    }
    return result;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const gpa = arena.allocator();
    var monkeys = try makeInput(gpa, "input.txt");

    var round: usize = 1;
    while (round <= 20) : (round += 1) {
        print("Round {}\n", .{round});
        for (monkeys.items) |*monkey, monkeyId| {
            var m: *Monkey = monkey;
            print("  Monkey {} - Items {}\n", .{ monkeyId, m.itemLen });
            while (m.itemLen > 0) {
                m.*.inspectCount += 1;
                const item = m.*.takeFirstItem();
                const worryLevel = @divFloor(m.calc(item), 3);
                print("    Inspect item {} - Worry Level = {}\n", .{ item, worryLevel });
                const idx = switch (@mod(worryLevel, m.divBy) == 0) {
                    true => @intCast(usize, m.yes),
                    false => @intCast(usize, m.no),
                };
                var targetMonkey: *Monkey = &monkeys.items[idx];
                targetMonkey.*.receive(worryLevel);
                print("      Throw to Monkey {}\n", .{idx});
            }
        }
        print("\nInventory check after Round {}:\n", .{ round });
        for (monkeys.items) |mo, moId| {
            var mok: Monkey = mo;
            print("Monkey {}: {any}\n", .{ moId, mok.items[0..mok.itemLen] });
        }
        print("\n", .{});
        print("--------------------------\n", .{});
    }

    var activeList = ArrayList(i32).init(gpa);
    for (monkeys.items) |mo| {
        try activeList.append(mo.inspectCount);
    }
    std.sort.sort(i32, activeList.items, {}, std.sort.desc(i32));

    const result = activeList.items[0] * activeList.items[1];
    print("Part 1 = {}\n", .{result});
}
