local M = {}

---@return table
function M.lazy_opts()
	return {
		dev = {
			path = '~/dev/thecontinium/',
		},
		performance = {
			rtp = {
				disabled_plugins = {
					'gzip',
					'vimballPlugin',
					'matchit',
					'matchparen',
					'2html_plugin',
					'tarPlugin',
					'netrwPlugin',
					'tutor',
					-- "zipPlugin",
				},
			},
		},
		concurrency = 10,
	}
end

return M
