const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList(*FileEntry);
const DirectoryMap = std.StringHashMap(*FileEntry);

// STOP: this file does not work

const FileEntry = struct {
    name: []const u8,
    size: u64,
    child: ArrayList,
    parent: ?*FileEntry,

    pub fn new(allocator: std.mem.Allocator, name: []const u8) FileEntry {
        return .{ .name = name, .size = 0, .child = ArrayList.init(allocator), .parent = null };
    }

    pub fn append(self: *FileEntry, child: *FileEntry) !void {
        try self.child.append(child);
        child.parent = self;
        self.updateSize();
    }

    pub fn updateSize(self: *FileEntry) void {
        for (self.child.items) |entry| {
            self.size += entry.size;
        }
        if (self.parent != null) {
            self.parent.?.updateSize();
        }
    }
};

pub fn readInputFile(allocator: std.mem.Allocator) ![]const u8 {
    const file = try std.fs.cwd().openFile("../input.txt", .{ .mode = .read_only });
    defer file.close();
    const stat = try file.stat();
    const fileSize = stat.size;
    return try file.reader().readAllAlloc(allocator, fileSize);
}

pub fn startsWith(haystack: []const u8, needle: []const u8) bool {
    return std.mem.startsWith(u8, haystack, needle);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const content = try readInputFile(allocator);
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var readIter = std.mem.tokenize(u8, content, "\n");
    while (readIter.next()) |line| {
        try lines.append(line);
    }

    var i: usize = 0;
    var dirMap = DirectoryMap.init(allocator);
    var root = FileEntry.new(allocator, "/");
    try dirMap.put("/", &root);
    var head = &root;

    while (i < lines.items.len) {
        var currentLine = lines.items[i];
        if (startsWith(currentLine, "$ cd ")) {
            const targetFolder = currentLine[5..];
            var dir = dirMap.get(targetFolder);
            if (dir != null) {
                head = dir.?;
            }
            i += 1;
        } else if (startsWith(currentLine, "$ ls")) {
            i += 1;
            while (i < lines.items.len and !startsWith(lines.items[i], "$")) {
                currentLine = lines.items[i];
                if (!startsWith(currentLine, "dir")) {
                    var iter = std.mem.tokenize(u8, currentLine, " ");
                    const sizeStr = iter.next().?;
                    const nameStr = iter.next().?;
                    const fileSize: u64 = try std.fmt.parseInt(u64, sizeStr, 10);
                    var file = FileEntry.new(allocator, nameStr);
                    file.size = fileSize;
                    try head.append(&file);
                } else {
                    const dirName = currentLine[4..];
                    var dir = FileEntry.new(allocator, dirName);
                    try head.append(&dir);
                    try dirMap.put(dirName, &dir);
                }
                i += 1;
            }
        }
    }

    print("VALUE {}", .{root.size});
}
