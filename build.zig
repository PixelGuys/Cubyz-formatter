const std = @import("std");

pub fn build(b: *std.Build) void {
	const target = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});

	const modified_std_lib = b.lazyDependency("modified_std_lib", .{
		.target = target,
		.optimize = optimize,
	}) orelse {
		std.log.info("Downloading modified_std_lib dependency.", .{});
		return;
	};

	const exe = b.addExecutable(.{
		.name = "Cubyz-fmt",
		.root_module = b.createModule(.{
			.root_source_file = b.path("src/main.zig"),
			.target = target,
			.optimize = optimize,
		}),
		.zig_lib_dir = modified_std_lib.path("lib"),
	});

	const zig_fmt_module = b.addModule("zig fmt", .{
		.root_source_file = modified_std_lib.path("src/fmt.zig"),
		.target = target,
		.optimize = optimize,
	});
	exe.root_module.addImport("zig fmt", zig_fmt_module);

	b.installArtifact(exe);

	const run_step = b.step("run", "Run the app");

	const run_cmd = b.addRunArtifact(exe);
	run_step.dependOn(&run_cmd.step);

	run_cmd.step.dependOn(b.getInstallStep());

	if (b.args) |args| {
		run_cmd.addArgs(args);
	}
}
