const std = @import("std");

pub fn main() !void {
    const file_path = "meow.txt";
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const ally = gpa.allocator();

    var cwd = std.fs.cwd();
    const max_bytes = 16 * 1024 * 1024;
    const text = try cwd.readFileAlloc(ally, file_path, max_bytes);

    const stdout = std.fs.File.stdout();
    var stdoutbuffer: [1024]u8 = undefined;

    var s = stdout.writer(&stdoutbuffer);
    const stdo = &s.interface;

    try stdo.writeAll(text);
    try stdo.flush();
    ally.free(text);
}
