local util = require("tairiki.util")
local M = {
	---@type table<string, tairiki.Palette>
	palettes = {},
	---@type table<string, boolean>
	loaded = {}
}

---@class tairiki.Palette
---@field bg string
---@field fg string
---@field bg_light? string
---@field bg_light2? string
---@field bg_light3? string
---@field fg_dark? string
---@field fg_dark2? string
---@field fg_dark3? string
---@field purple string
---@field green string
---@field orange string
---@field blue string
---@field yellow string
---@field cyan string
---@field red string
---@field comment string
---@field none string
---@field diag? tairiki.Palette.Diagnostic
---@field diff? tairiki.Palette.Diff
---@field syn? tairiki.Palette.Syntax
---@field x? table<string, string>
---@field group_x? fun(self: tairiki.Palette, opts: tairiki.Config): table<string, table<string, string|tairiki.Highlights>>

---@class tairiki.Palette.Diagnostic
---@field error? string
---@field info? string
---@field warn? string
---@field hint? string
---@field ok? string

---@class tairiki.Palette.Diff
---@field add? string
---@field remove? string
---@field change? string
---@field text? string

---@class tairiki.Palette.Syntax
---@field ident? string
---@field constant? string
---@field literal? string
---@field func? string
---@field string? string
---@field type? string
---@field keyword? string
---@field keyword_mod? string
---@field special? string
---@field delim? string
---@field exception? string
---@field operator? string

-- todo builtin palettes should also properly register themselves
M.palettes.dimmed = require "tairiki.palette.dimmed"
M.palettes.dark = require "tairiki.palette.dark"
M.palettes.light = require "tairiki.palette.light"

---@param name string name to regiter palette as
---@param base_colors tairiki.Palette|string
function M.register(name, base_colors)
	if type(base_colors) == "string" then
		return require("tairiki.palette." .. base_colors)
	else
	end
end

---@param which string
function M.load(which)
	local loaded = M.loaded[which]

	if not loaded then
		M.register(which, which)
	end

	return M.palettes[which]
end

function M.get_palette_bg_style(which)
	local p = M.palettes[which]
	local avg = util.rgb(p.bg)
	return ((avg[1] + avg[2] + avg[3]) / 3) > 0xe0 and "light" or "dark"
end

function M.gen_term_colors(p)
	p.terminal = vim.tbl_extend("keep", p.terminal or {}, {
		black         = util.lighten(p.bg_light3, 0.95),
		bright_black  = p.fg_dark3,
		red           = util.darken(p.red, 0.85),
		bright_red    = p.red,
		green         = util.darken(p.green, 0.85),
		bright_green  = p.green,
		yellow        = util.darken(p.yellow, 0.85),
		bright_yellow = p.yellow,
		blue          = util.darken(p.blue, 0.85),
		bright_blue   = p.blue,
		purple        = util.darken(p.purple, 0.85),
		bright_purple = p.purple,
		cyan          = util.darken(p.cyan, 0.85),
		bright_cyan   = p.cyan,
		white         = p.fg,
		bright_white  = util.lighten(p.fg, 0.85)
	})
end

return M
