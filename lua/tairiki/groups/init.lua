local M = {}

-- realname > modname
M.plugins = {
	["neovim"]          = "neovim",
	["semantic-tokens"] = "semantic_tokens",
	["telescope.nvim"]  = "telescope",
	["treesitter"]      = "treesitter",
}

function M.flatten_styles(groups)
	for _, hl in pairs(groups) do
		if type(hl.style) == "table" then
			for s, v in pairs(hl.style) do
				hl[s] = v
			end
			hl.style = nil
		end
	end
end

function M.load(opts, colors)
	local groups = {
		neovim = true
	}

	if not opts.plugins.none then
		if opts.plugins.all then
			for _, module in pairs(M.plugins) do
				groups[module] = true
			end
		elseif opts.plugins.auto then
			vim.notify("tairiki: todo plugin auto discovery")
		end

		for plugin, module in pairs(M.plugins) do
			local cfg = opts.plugins[plugin]
			cfg = cfg == nil and opts.plugins[module] or cfg
			if cfg ~= nil then
				if type(cfg) == "table" then
					cfg = cfg.enabled
				end
				groups[module] = cfg or nil
			end
		end
	end

	local ret = {}
	for group, enabled in pairs(groups) do
		if enabled then
			local ok, groupmod = pcall(require, "tairiki.groups." .. group)
			if not ok then
				vim.notify("tairiki: unable to load group` " .. group)
			end
			for g, hl in pairs(groupmod.get(colors, opts)) do
				ret[g] = hl
			end
		end
	end

	ret = vim.tbl_extend("force", ret, colors.group_x and colors:group_x(opts) or {})

	M.flatten_styles(ret)

	return ret
end

return M
