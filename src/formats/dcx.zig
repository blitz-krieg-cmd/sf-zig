const std = @import("std");

pub const Block = extern struct {
    unk00: i32, // 0
    dataOffset: i32,
    dataLength: i32,
    unk0C: i32, // 1
};

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

    // EDGE
    egdt: [4]u8, // EgdT
    unk50: i32, // 0x10100
    unk54: i32, // 0x24
    unk58: i32, // 0x10
    unk5C: i32, // x10000
    lastBlockUncompressedSize: i32,
    egdtSize: i32, // From before "EgdT" to dca end
    blockCount: i32,
    unk6C: i32, // Assert(unk6C == 0x100000);
    blocks: []Block,

    pub fn read_data() void {}

    pub fn ensure_type(self: *const HEADER) bool {
        if (std.mem.eql(u8, &self.dcx, "DCX\x00") or std.mem.eql(u8, &self.dcx, "DCP\x00")) {
            return true;
        }
        return false;
    }
};

pub const DCX = extern struct {
    header: HEADER,
};
