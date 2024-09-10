const std = @import("std");
const formats = @import("sf.zig");

pub fn main() !void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) std.testing.expect(false) catch @panic("TEST FAIL");
    }

    // file work
    var file = try std.fs.openFileAbsolute("E:/SteamLibrary/steamapps/common/DARK SOULS REMASTERED/param/GameParam/GameParam.parambnd.dcx", .{ .mode = .read_only });
    defer file.close();

    // file into buffer
    const fileBytes = try file.readToEndAlloc(allocator, try file.getEndPos());
    defer allocator.free(fileBytes);

    const dcx = try formats.ReadDCX(fileBytes, &allocator);
    const bnd = try formats.ReadBND3(dcx.uncompressedBytes, &allocator);

    std.debug.print("{c}\n", .{bnd.header.magic});
}
