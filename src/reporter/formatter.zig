//! Formatters process diagnostics for a `Reporter`.

pub const Github = @import("formatters/GithubFormatter.zig");
pub const Graphical = @import("formatters/GraphicalFormatter.zig");
pub const JSON = @import("formatters/JSONFormatter.zig");

pub const Meta = struct {
    report_statistics: bool,
};

pub const Kind = enum {
    ascii,
    unicode,
    github,
    json,
};

pub const Color = enum {
    /// Determine whether stderr is a terminal or not automatically.
    auto,
    /// Assume stderr is not a terminal.
    off,
    /// Assume stderr is a terminal.
    on,

    pub fn get_tty_conf(color: Color) std.io.tty.Config {
        return switch (color) {
            .auto => std.io.tty.detectConfig(std.io.getStdErr()),
            .on => .escape_codes,
            .off => .no_color,
        };
    }

    pub fn renderOptions(color: Color) std.zig.ErrorBundle.RenderOptions {
        return .{
            .ttyconf = get_tty_conf(color),
        };
    }
};

pub const FormatError = Writer.Error || Allocator.Error;

const std = @import("std");
const Writer = std.io.AnyWriter;
const Allocator = std.mem.Allocator;
