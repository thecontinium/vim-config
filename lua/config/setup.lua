local M = {}

---@return table
function M.lazy_opts()
	return {
		performance = {
			rtp = {
				disabled_plugins = {
					"gzip",
					"vimballPlugin",
					"matchit",
					"matchparen",
					"2html_plugin",
					"tarPlugin",
					"netrwPlugin",
					"tutor",
					-- "zipPlugin",
				},
			},
		},
		concurrency = 10,
	}
end

return M
