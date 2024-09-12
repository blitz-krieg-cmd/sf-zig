# SoulsFormats but in Zig
Currently a very WIP library being created slowly in my free time. It is supposed to mirror the functionality of [SoulsFormats](https://github.com/JKAnderson/SoulsFormats/tree/er). But written in [Zig](https://ziglang.org). Feel free to contribute but I don't have any clear direction on how I want this project to be structured so please be mindful of that. If you have any questions feel free to ask them.


# Formats
Basic descriptions are provided below. Checkmarks show library progress on file type.

State | Format | Extension | Description
------ | ------ | --------- | -----------
❌ Incomplete |  BHD5 | .bhd, .bhd5 | The header file for the large primary file archives used by most games
✏️ Working |  BND3 | .\*bnd | A general-purpose file container used before DS2
❌ Incomplete  |  BTAB | .btab | Controls lightmap atlasing
❌ Incomplete  |  BTL | .btl | Configures point light sources
❌ Incomplete  |  BTPB | .btpb | Contains baked light probes for a map
❌ Incomplete  |  BXF3 | .\*bhd + .\*bdt | Equivalent to BND3 but with a separate header and data file
❌ Incomplete  |  CCM | .ccm | Determines font layout and texture mapping
❌ Incomplete  |  CLM2 | .clm | A FLVER companion format that has something to do with cloth
✏️ Working  |  DCX | .dcx | A simple wrapper for a single compressed file
❌ Incomplete |  DRB | .drb | Controls GUI layout and styling
❌ Incomplete |  EDD | .edd | An ESD companion format that gives friendly names for various elements
❌ Incomplete |  EMELD | .eld, .emeld | Stores friendly names for EMEVD events
❌ Incomplete |  EMEVD | .evd, .emevd | Event scripts
❌ Incomplete |  ENFL | .entryfilelist | Specifies assets to preload when going through a load screen
❌ Incomplete |  ESD | .esd | Defines a set of state machines used to control characters, menus, dialog, and/or map events
❌ Incomplete |  F2TR | .flver2tri | A FLVER companion format that links the vertices to the FaceGen system
❌ Incomplete |  FLVER | .flv, .flver | FromSoftware's standard 3D model format
❌ Incomplete |  FMG | .fmg | A collection of strings with corresponding IDs used for most game text
❌ Incomplete |  GPARAM | .fltparam, .gparam | A generic graphics configuration format
❌ Incomplete |  GRASS | .grass | Specifies meshes for grass to be dynamically placed on
❌ Incomplete |  LUAGNL | .luagnl | A list of global variable names for Lua scripts
❌ Incomplete |  LUAINFO | .luainfo | Information about AI goals for Lua scripts
❌ Incomplete |  MCG | .mcg | A high-level navigation format used in DeS and DS1
❌ Incomplete |  MCP | .mcp | Another high-level navigation format used in DeS and DS1
❌ Incomplete |  MSB | .msb | The main map format, listing all enemies, collisions, trigger volumes, etc
❌ Incomplete |  MTD | .mtd | Defines some material and shader properties; referenced by FLVER materials
❌ Incomplete |  NVM | .nvm | The navmesh format used in DeS and DS1
❌ Incomplete |  PARAM | .param | A generic configuration format
❌ Incomplete |  PARAMDEF | .def, .paramdef | A companion format that specifies the format of data in a param
❌ Incomplete |  PARAMTDF | .tdf | A companion format that provides friendly names for enumerated types in params
❌ Incomplete |  RMB | .rmb | Controller rumble effects for all games
❌ Incomplete |  TPF | .tpf | A container for platform-specific texture data


# Misc
Note: Submodules aren't required for development but are there for in editor file reference.

Note: Cannot upload game files to github for reference and testing but we could likely use SoulsFormats to quickly make some mock files for testing.

Personal Command Note:
`zig build run -- "E:/SteamLibrary/steamapps/common/DARK SOULS REMASTERED/param/GameParam/GameParam.parambnd.dcx"`
