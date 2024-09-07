const std = @import("std");

const formats = @import("sf.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) std.testing.expect(false) catch @panic("TEST FAIL");
    }

    var file = try std.fs.openFileAbsolute("E:/SteamLibrary/steamapps/common/DARK SOULS REMASTERED/menu/ENGLISH/menu_local.tpf.dcx", .{ .mode = .read_only });
    defer file.close();

    const buf = try file.readToEndAlloc(allocator, try file.getEndPos());
    defer allocator.free(buf);

    var reader = formats.Reader.init(buf);
    const header = try reader.read(formats.DCX_HEADER);
    const bytes = try reader.readRestAsBytes();
    std.debug.print("{}\n", .{header});
    std.debug.print("{any}\n", .{bytes});
}
