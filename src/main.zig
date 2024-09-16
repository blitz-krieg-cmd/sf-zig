const std = @import("std");

const formats = @import("sf.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const argv = std.process.argsAlloc(allocator) catch |err| {
        std.log.err("Error: {?}", .{err});
        return;
    };
    defer std.process.argsFree(allocator, argv);

    if (argv.len == 1) {
        std.log.info("Usage: {s} <filename> <options>\n", .{argv[0]});
        return;
    }

    const filePath = argv[1];
    var file = std.fs.openFileAbsolute(
        filePath,
        .{ .mode = .read_only },
    ) catch |e| switch (e) {
        error.FileNotFound => {
            std.log.err("File '{s}' does not exist\n", .{filePath});
            return;
        },
        else => {
            std.log.err("{?}\n", .{e});
            return;
        },
    };
    defer file.close();

    const fileBytes = try file.readToEndAlloc(allocator, try file.getEndPos());
    defer allocator.free(fileBytes);

    const dcx = try formats.ReadDCX(fileBytes, allocator);
    const bnd = try formats.ReadBND3(dcx.uncompressedBytes, allocator);

    // std.log.info("{s}", .{bnd.header.magic});
    // std.log.info("{any}", .{bnd.files.len});
    std.log.info("{s}", .{bnd.files[1].bytes[0..]});
}
