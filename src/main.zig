const std = @import("std");

pub const HEADER = extern struct {
    dcx: [4]u8, // DCX\0
    unk04: i32, // 0x10000 || 0x11000
    dcsOffset: i32, // 0x18
    dcpOffset: i32, // 0x24
    unk10: i32, // 0x24 || 0x44
    unk14: i32, // In EDGE, size from 0x20 to end of block headers
    dcs: [4]u8, // DCS\0
    uncompressedSize: u32,
    compressedSize: u32,
    dcp: [4]u8, // DCP\0
    format: [4]u8, // DFLT || EDGE || KRAK
    unk2C: i32, // 0x20
    unk30: u8, // 6 || 8 || 9
    unk31: u8, // 0
    unk32: u8, // 0
    unk33: u8, // 0
    unk34: i32, // 0 || 0x10000
    unk38: i32, // 0
    unk3C: i32, // 0
    unk40: i32,
    dca: [4]u8, // DCA\0
    dcaSize: i32, // From before "DCA" to dca end
};

pub const DCX = extern struct {
    header: HEADER,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) std.testing.expect(false) catch @panic("TEST FAIL");
    }

    var file = try std.fs.openFileAbsolute("C:\\Program Files (x86)\\Steam\\steamapps\\common\\DARK SOULS REMASTERED\\param\\GameParam\\GameParam.parambnd.dcx", .{ .mode = .read_only });
    defer file.close();

    const buf = try file.readToEndAlloc(allocator, try file.getEndPos());
    defer allocator.free(buf);

    var stream = std.io.fixedBufferStream(buf);
    const dcx = try stream.reader().readStruct(DCX);

    const magic = std.mem.sliceTo(&dcx.header.dcx, 0);
    const format = std.mem.sliceTo(&dcx.header.format, 0);

    std.debug.print("{c}", .{magic});
    std.debug.print("{c}", .{format});
}
