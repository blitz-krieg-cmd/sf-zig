const std = @import("std");
const dcx = @import("dcx.zig");

pub fn main() !void {
    std.debug.print("{any}\n", .{try dcx.is("E:\\SteamLibrary\\steamapps\\common\\DARK SOULS REMASTERED\\param\\GameParam\\GameParam.parambnd.dcx")});
    std.debug.print("{s}\n", .{try dcx.decompress("E:\\SteamLibrary\\steamapps\\common\\DARK SOULS REMASTERED\\param\\GameParam\\GameParam.parambnd.dcx")});
}
