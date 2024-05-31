return {

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = (vim.list_extend(opts.ensure_installed, { 'clojure' }))
		end,
	},

	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"bash-language-server",
				"clojure-lsp",
				"vim-language-server",
				"python-lsp-server",
			})
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		keys = {
			{ '<localleader>w', '<cmd>ObsidianQuickSwitch<CR>' },
		},
	},

	-- {
	-- 	'mfussenegger/nvim-lint',
	-- 	opts = {
	-- 		linters_by_ft = {
	-- 			python = { 'mypy', 'ruff' },
	-- 			-- Use the "*" filetype to run linters on all filetypes.
	-- 			-- ['*'] = { 'global linter' },
	-- 			-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
	-- 			-- ['_'] = { 'fallback linter' },
	-- 		},
	-- 	},
	-- },
	--
	-- {
	-- 	'stevearc/conform.nvim',
	-- 	opts = {
	-- 		formatters_by_ft = {
	-- 			python = { "black" },
	-- 		},
	-- 	},
	-- },
	--
	-----------------------------------------------------------------------------
	{ 'folke/persistence.nvim', enabled = false },

	{
		'olimorris/persisted.nvim',
		event = 'VimEnter',
		priority = 1000,
		opts = {
			autoload = true,
			follow_cwd = false,
			ignored_dirs = { '/usr', '/opt', '~/.cache', vim.env.TMPDIR or '/tmp' },
		},
		keys = {
			{ "<localLeader>s", "<cmd>Telescope persisted<cr>", desc = "Telescope session", },
		},
		config = function(_, opts)
			if vim.g.in_pager_mode or vim.env.GIT_EXEC_PATH ~= nil then
				-- Do not autoload if stdin has been provided, or git commit session.
				opts.autoload = false
				opts.autosave = false
			end
			require('persisted').setup(opts)
		end,
		init = function()
			require("telescope").load_extension("persisted")
			-- Detect if stdin has been provided.
			vim.g.in_pager_mode = false
			vim.api.nvim_create_autocmd('StdinReadPre', {
				group = vim.api.nvim_create_augroup('rafi_persisted', {}),
				callback = function()
					vim.g.in_pager_mode = true
				end,
			})
			-- Close all floats before loading a session. (e.g. Lazy.nvim)
			vim.api.nvim_create_autocmd('User', {
				group = 'rafi_persisted',
				pattern = 'PersistedLoadPre',
				callback = function()
					for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
						if vim.api.nvim_win_get_config(win).zindex then
							vim.api.nvim_win_close(win, false)
						end
					end
				end,
			})
			-- Close all plugin owned buffers before saving a session.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedSavePre',
				group = 'rafi_persisted',
				callback = function()
					-- Detect if window is owned by plugin by checking buftype.
					local current_buffer = vim.api.nvim_get_current_buf()
					for _, win in ipairs(vim.fn.getwininfo()) do
						local buftype = vim.bo[win.bufnr].buftype
						if buftype ~= '' and buftype ~= 'help' then
							-- Delete plugin owned window buffers.
							if win.bufnr == current_buffer then
								-- Jump to previous window if current window is not a real file
								vim.cmd.wincmd('p')
							end
							vim.api.nvim_buf_delete(win.bufnr, {})
						end
					end
				end,
			})
			-- Before switching to a different session using Telescope, save and stop
			-- current session to avoid previous session to be overwritten.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedTelescopeLoadPre',
				group = 'rafi_persisted',
				callback = function()
					require('persisted').save()
					require('persisted').stop()
				end,
			})
			-- After switching to a different session using Telescope, start it so it
			-- will be auto-saved.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedTelescopeLoadPost',
				group = 'rafi_persisted',
				callback = function(session)
					require('persisted').start()
					print('Started session ' .. session.data.name)
				end,
			})
		end,
	},
}
