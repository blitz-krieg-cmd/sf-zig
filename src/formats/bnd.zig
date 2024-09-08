const std = @import("std");
const Reader = @import("../sf.zig").Reader;

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
    endian: std.builtin.Endian,
    //files: []File,
};

pub fn read(bytes: []const u8) !BND3 {
    // reader from buffer
    var reader = Reader.init(bytes);
    const header = try reader.read(HEADER);
    //const fileBytes = try reader.readRestAsBytes();

    const bnd: BND3 = .{
        .header = header,
        .endian = std.builtin.Endian.big,
        //.files = readFiles(fileBytes),
    };

    return bnd;
}

// pub fn readFiles(bytes: []const u8) ![]File {
//     const size = @sizeOf(File);

// }
