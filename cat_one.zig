const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const ally = gpa.allocator();

    const args = try std.process.argsAlloc(ally);
    defer std.process.argsFree(ally, args);

    var cwd = std.fs.cwd();
    const max_bytes = 16 * 1024 * 1024;

    var stdoutbuffer: [1024]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&stdoutbuffer);
    var stdo = &stdout.interface;

    for (args[1..]) |file_path| {
        const text = try cwd.readFileAlloc(ally, file_path, max_bytes);
        defer ally.free(text);
        try stdo.writeAll(text);
    }

    try stdo.flush();
}
