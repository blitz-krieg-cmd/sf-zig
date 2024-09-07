const std = @import("std");
const bigToNative = std.mem.bigToNative;

pub const Reader = struct {
    bytes: []const u8,
    index: usize,

    pub fn init(bytes: []const u8) Reader {
        return .{ .bytes = bytes, .index = 0 };
    }

    fn readInt(self: *Reader, comptime T: type) !T {
        const size = @sizeOf(T);
        if (self.index + size > self.bytes.len) return error.EndOfStream;

        const slice = self.bytes[self.index .. self.index + size];
        const value = @as(*align(1) const T, @ptrCast(slice)).*;

        self.index += size;
        return bigToNative(T, value);
    }

    fn readFloat(self: *Reader) !f32 {
        const size = @sizeOf(f32);
        if (self.index + size > self.bytes.len) return error.EndOfStream;

        const slice = self.bytes[self.index .. self.index + size];
        const value = @as(*align(1) const u32, @ptrCast(slice)).*;

        self.index += size;
        return @as(f32, @bitCast(bigToNative(u32, value)));
    }

    fn readStruct(self: *Reader, comptime T: type) !T {
        const fields = std.meta.fields(T);

        var item: T = undefined;
        inline for (fields) |field| {
            @field(item, field.name) = try self.read(field.type);
        }

        return item;
    }

    pub fn readRestAsBytes(self: *Reader) ![]const u8 {
        const size = @sizeOf(u8);
        if (self.index + size > self.bytes.len) return error.EndOfStream;

        return self.bytes[self.index..self.bytes.len];
    }

    pub fn read(self: *Reader, comptime T: type) !T {
        return switch (@typeInfo(T)) {
            .Int => try self.readInt(T),
            .Float => try self.readFloat(),
            .Array => |array| {
                var arr: [array.len]array.child = undefined;
                var index: usize = 0;
                while (index < array.len) : (index += 1) {
                    arr[index] = try self.read(array.child);
                }
                return arr;
            },
            .Struct => try self.readStruct(T),
            else => @compileError("unsupported type"),
        };
    }
};
