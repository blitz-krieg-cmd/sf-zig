// Flags that control editor behavior for a field.
const EditFlag = enum(u8) {
    None = 0, // Value is editable and does not wrap.
    Wrap = 1, // Value wraps around when scrolled past the minimum or maximum.
    Lock = 4, // Value may not be edited.
};

// Information about a field present in each row in a param.
const DefType = union {
    i8: i8,
    u8: u8,
    i16: i16,
    u16: u16,
    i32: i32,
    u32: u32,
    bool: [4]u8,
    f32: f32,
    angle: f32,
    f64: f64,
    dummy: []u8,
    // fixstr: []u8, // Fixed-width Shift-JIS string.
    // fixstrW: []u8 // Fixed-width UTF-16 string.
};

// Information about a field present in each row in a param.
const Field = struct {
    displayname: []u8, // Name to display in the editor.
    displayType: DefType, // Type of value to display in the editor.
    displayFormat: []u8, // Printf-style format string to apply to the value in the editor.
    default: DefType, // Default value for new rows.
    minimum: DefType, // Minimum valid value
    maximum: DefType, // Maximum valid value
    increment: DefType, // Amount of increase or decrease per step when scrolling in the editor.
    editFlag: EditFlag, // Flags determining behavior of the field in the editor.
    arrayLength: usize, // Number of elements for array types; only supported for dummy8, fixstr, and fixstrW.
    description: []u8, // Optional description of the field; may be null.
    internalType: []u8, // Type of the value in the engine; may be an enum type.
    internalName: []u8, // Name of the value in the engine; not present before version 102.
    bitSize: i32, // Number of bits used by a bitfield; only supported for unsigned types, -1 when not used.
    sortID: i32, // Fields are ordered by this value in the editor; not present before version 104.
    unkB8: []u8, // Unknown; appears to be an identifier. May be null, only supported in versions >= 200, only present in version 202 so far.
    unkC0: []u8, // Unknown; appears to be a param type. May be null, only supported in versions >= 200, only present in version 202 so far.
    unkC8: []u8, // Unknown; appears to be a display string. May be null, only supported in versions >= 200, only present in version 202 so far.
};

// One cell in one row in a param.
const Cell = struct {
    def: Field, // The paramdef field that describes this cell.
    value: DefType, // The value of this cell.
};

// One row in a param file.
const Row = struct {
    id: i32, // The ID number of this row.
    name: []u8, // A name given to this row; no functional significance, may be null.
    cells: []Cell, // Cells contained in this row.
    dataOffset: i64,
};

// A general-purpose configuration file used throughout the series.
const PARAM = struct {
    bigEndian: bool, // Whether the file is big-endian; true for PS3/360 files, false otherwise.
    // Format2D: FormatFlags1 // Flags indicating format of the file.
    // Format2E: FormatFlags2 // More flags indicating format of the file.
    paramdefFormatVersion: u8, // Originally matched the paramdef for version 101, but since is always 0 or 0xFF.
    unk06: i16, // Unknown.
    paramdefDataVersion: i16, // Indicates a revision of the row data structure.
    paramType: []u8, // Identifies corresponding params and paramdefs.
    detectedSize: i64, // Automatically determined based on spacing of row offsets; -1 if param had no rows.
    rows: []Row, // The rows of this param.
    appliedParamdef: PARAMDEF, // The current applied PARAMDEF.
};

// A companion format to params that describes each field present in the rows. Extension: .def, .paramdef
const PARAMDEF = struct {
    dataVersion: i16, // Indicates a revision of the row data structure.
    paramType: []u8, // Identifies corresponding params and paramdefs.
    bigEndian: bool, // True for PS3 and X360 games, otherwise false.
    unicode: bool, // If true, certain strings are written as UTF-16; if false, as Shift-JIS.
    // 101 - Enchanted Arms, Chromehounds, Armored Core 4/For Answer/V/Verdict Day, Shadow Assault: Tenchu
    // 102 - Demon's Souls
    // 103 - Ninja Blade, Another Century's Episode: R
    // 104 - Dark Souls, Steel Battalion: Heavy Armor
    // 106 - Elden Ring (deprecated ObjectParam)
    // 201 - Bloodborne
    // 202 - Dark Souls 3
    // 203 - Elden Ring
    formatVersion: i16, // Determines format of the file.
    variableEditorValueTypes: bool = .formatVersion >= 203, // Whether field default, minimum, maximum, and increment may be variable type. If false, they are always floats.
    fields: []Field, // Fields in each param row, in order of appearance.

    pub fn Create() PARAMDEF {
        var def: PARAMDEF = undefined;
        def.paramType = "";
        def.formatVersion = 104;
        def.fields = undefined;
        return def;
    }
};

test "paramdef" {
    const std = @import("std");
    const expect = std.testing.expect;

    const def: PARAMDEF = PARAMDEF.Create();

    try expect(def.formatVersion == 104);
}
