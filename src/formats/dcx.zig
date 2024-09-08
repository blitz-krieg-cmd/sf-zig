const std = @import("std");
const Reader = @import("../sf.zig").Reader;

pub const HEADER = extern struct {
    magic: [4]u8, // DCX\0
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
    unk30: i8, // 6 || 8 || 9
    unk31: i8, // 0
    unk32: i8, // 0
    unk33: i8, // 0
    unk34: i32, // 0 || 0x10000
    unk38: i32, // 0
    unk3C: i32, // 0
    unk40: i32,
    dca: [4]u8, // DCA\0
    dcaSize: i32, // From before "DCA" to dca end
};

pub const DCX = struct {
    header: HEADER,
    decompressedBytes: []const u8,
    lengthOfBytes: usize,
};

pub fn read(bytes: []const u8) !DCX {
    // reader from buffer
    var reader = Reader.init(bytes);
    const header = try reader.read(HEADER);
    const compressedBytes = try reader.readRestAsBytes();

    // stream reader from reader
    var stream = std.io.fixedBufferStream(compressedBytes[0..]);
    const sreader = stream.reader();

    // decompressor reader from stream reader
    var dcp = std.compress.zlib.decompressor(sreader);

    // TODO: this is shit, need to work with getting this to be a variable length with header.uncompressedSize
    var decompressedBytes: [8000000]u8 = undefined;

    // decompressed data read from decompressor reader
    const decompressedBytesLength = try dcp.reader().readAll(decompressedBytes[0..]);

    const dcx: DCX = .{
        .header = header,
        .decompressedBytes = decompressedBytes[0..decompressedBytesLength],
        .lengthOfBytes = decompressedBytesLength,
    };

    return dcx;
}
