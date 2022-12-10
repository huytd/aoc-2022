const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Instruction = struct {
    opcode: OpCode,
    param: i32,

    const OpCode = union(enum) { Add, Noop };

    pub fn new(opcode: OpCode, param: i32) Instruction {
        return Instruction{ .opcode = opcode, .param = param };
    }
};

const VirtualMachine = struct {
    program: std.ArrayList(Instruction).Slice,
    pc: usize,
    cycle: i32,
    X: i32,
    pending: bool,
    display: [240]u8,

    debug: struct {
        next: i32,
        sum: i32,
    },

    pub fn new(program: std.ArrayList(Instruction).Slice) VirtualMachine {
        return VirtualMachine{
            .program = program,
            .pc = 0,
            .cycle = 1,
            .X = 1,
            .pending = false,
            .display = [_]u8{0} ** 240,
            .debug = .{ .next = 20, .sum = 0 },
        };
    }

    pub fn run(self: *VirtualMachine) void {
        while (self.pc < self.program.len) {
            const instr = self.program[self.pc];
            if (self.cycle == self.debug.next) {
                print(">> {}th cycle -> {} * {} = {}\n", .{ self.cycle, self.cycle, self.X, self.cycle * self.X });
                self.debug.sum += self.cycle * self.X;
                self.debug.next += 40;
            }
            switch (instr.opcode) {
                .Add => {
                    if (!self.pending) {
                        self.pending = true;
                    } else {
                        self.pending = false;
                        self.X += instr.param;
                        self.pc += 1;
                    }
                },
                .Noop => {
                    self.pc += 1;
                },
            }
            print("Cycle #{} - PC = {} - X = {}\n", .{ self.cycle, self.pc, self.X });
            if (@mod(self.cycle, 40) == 0) {
                self.display[@intCast(usize, self.cycle-1)] = '$';
            } else {
                if (std.math.absCast(self.X - @mod(self.cycle, 40)) <= 1) {
                    self.display[@intCast(usize, self.cycle-1)] = '#';
                } else {
                    self.display[@intCast(usize, self.cycle-1)] = '.';
                }
            }
            self.cycle += 1;
        }
    }
};

pub fn readInputFile(allocator: std.mem.Allocator) !ArrayList(Instruction) {
    const content = @embedFile("input.txt");
    var lines = ArrayList(Instruction).init(allocator);
    var iter = std.mem.tokenize(u8, content, "\n");
    while (iter.next()) |line| {
        if (line.len != 0) {
            var parts = std.mem.tokenize(u8, line, " ");
            const opcodeText = parts.next().?;
            var opcode = Instruction.OpCode.Noop;
            if (std.mem.eql(u8, opcodeText, "addx")) {
                opcode = Instruction.OpCode.Add;
            }
            const paramText = parts.next() orelse "0";
            const param = try std.fmt.parseInt(i32, paramText, 10);
            try lines.append(Instruction.new(opcode, param));
        }
    }
    return lines;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const program: ArrayList(Instruction) = try readInputFile(allocator);
    var vm = VirtualMachine.new(program.items);
    vm.run();

    print("Part 1 = {}\n", .{vm.debug.sum});

    var displayIter = std.mem.tokenize(u8, &vm.display, "$");
    while (displayIter.next()) |line| {
        print("{s}\n", .{line});
    }
}
