const std = @import("std");
const process = std.process;
const fmt = @import("zig fmt");

pub fn main(init: std.process.Init) !void {
	try fmt.run(init.gpa, init.arena.allocator(), init.io, (try init.minimal.args.toSlice(init.arena.allocator()))[1..]);
}
