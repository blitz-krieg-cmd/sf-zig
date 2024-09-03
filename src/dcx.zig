const std = @import("std");

pub fn is(filePath: []const u8) !bool {
    var file = try std.fs.openFileAbsolute(filePath, .{ .mode = .read_only });
    defer file.close();

    var bytes = try file.reader().readBytesNoEof(4);
    const magic = bytes[0..4];
    return std.mem.eql(u8, magic, "DCP\x00") or std.mem.eql(u8, magic, "DCX\x00");
}

pub fn decompress(filePath: []const u8) ![]const u8 {
    var file = try std.fs.openFileAbsolute(filePath, .{ .mode = .read_only });
    defer file.close();

    // maybe use a reader thingy stream and get a seekable buffer

    const magic = try file.reader().readBytesNoEof(4);
    if (std.mem.eql(u8, &magic, "DCP\x00")) {
        const format = try file.reader().readBytesNoEof(4);

        if (std.mem.eql(u8, &format, "DFLT")) {
            return "DFLT";
        } else if (std.mem.eql(u8, &format, "EDGE")) {
            return "EDGE";
        }
    } else if (std.mem.eql(u8, &magic, "DCX\x00")) {
        const format = try file.reader().readBytesNoEof(4);

        if (std.mem.eql(u8, &format, "EDGE")) {
            return "EDGE";
        } else if (std.mem.eql(u8, &format, "DFLT")) {
            return "DFLT";
        } else if (std.mem.eql(u8, &format, "KRAK")) {
            return "KRAK";
        }
    }

    return "FUCK";
}
