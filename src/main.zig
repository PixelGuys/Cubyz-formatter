const std = @import("std");
const process = std.process;
const fmt = @import("zig fmt");

pub fn main() !void {
	var gpa = std.heap.DebugAllocator(.{}).init;
	var arena = std.heap.ArenaAllocator.init(gpa.allocator());
	defer arena.deinit();
	const args = try process.argsAlloc(arena.allocator());
	try fmt.run(gpa.allocator(), arena.allocator(), args[1..]);
}
