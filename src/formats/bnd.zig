const std = @import("std");

// Minimal file information.
pub const None = 0;
// File is big-endian regardless of the big-endian byte.
pub const BigEndian = 0b0000_0001;
// Files have ID numbers.
pub const IDs = 0b0000_0010;
// Files have name strings; Names2 may or may not be set. Perhaps the distinction is related to whether it's a full path or just the filename?
pub const Names1 = 0b0000_0100;
// Files have name strings; Names1 may or may not be set.
pub const Names2 = 0b0000_1000;
// File data offsets are 64-bit.
pub const LongOffsets = 0b0001_0000;
// Files may be compressed.
pub const Compression = 0b0010_0000;
// Unknown.
pub const Flag6 = 0b0100_0000;
// Unknown.
pub const Flag7 = 0b1000_0000;

pub const File = extern struct {
    rawFlags: u8,
    unk01: u8,
    unk02: u8,
    unk03: u8,
    flags: u8,
    compressedSize: i32,
    dataOffsetL: u32,
};

pub const HEADER = extern struct {
    magic: [4]u8, // BND3
    version: [8]u8,
    rawFormat: u8, // is binary?
    bigEndian: i8, // 0 | 1
    bitBigEndian: i8, //  0 | 1
    unk0F: i8, // 0
    format: u8,
    fileCount: i32,
    fileHeadersEnd: i32, // Does not include padding before data starts
    unk18: i32,
    unk1C: i32,
};

pub const BND3 = struct {
    header: HEADER,
    bytes: []const u8,
};

pub fn read(bytes: []const u8, allocator: std.mem.Allocator) !BND3 {
    var fbs = std.io.fixedBufferStream(bytes);
    var reader = fbs.reader();
    const header = try reader.readStruct(HEADER);

    const remainingBytes = try reader.readAllAlloc(allocator, bytes.len);
    defer allocator.free(remainingBytes);

    const bnd: BND3 = .{
        .header = header,
        .bytes = remainingBytes[0..],
    };

    return bnd;
}

test "bnd" {
    const DCX = @import("dcx.zig");

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var file = try std.fs.openFileAbsolute("E:/SteamLibrary/steamapps/common/DARK SOULS REMASTERED/param/GameParam/GameParam.parambnd.dcx", .{ .mode = .read_only });
    defer file.close();

    const fileBytes = try file.readToEndAlloc(allocator, try file.getEndPos());
    defer allocator.free(fileBytes);

    const dcx = try DCX.read(fileBytes, allocator);
    const bnd = try read(dcx.uncompressedBytes, allocator);

    try std.testing.expect(std.mem.eql(u8, &bnd.header.magic, "BND3"));
    try std.testing.expect(bnd.header.bigEndian == 0 or bnd.header.bigEndian == 1);
    try std.testing.expect(bnd.header.bitBigEndian == 0 or bnd.header.bitBigEndian == 1);

    try std.testing.expect(dcx.uncompressedBytes.len > 0);
}
