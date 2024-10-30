return {

	{
		'nvim-lualine/lualine.nvim',
		opts = function(_, opts)
			opts.sections.lualine_b[2] = LazyVim.lualine.root_dir({ cwd = true })
		end,
	},

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			opts.ensure_installed = (
				vim.list_extend(opts.ensure_installed, { 'clojure' })
			)
		end,
	},

	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				'bash-language-server',
				'clojure-lsp',
				'vim-language-server',
				'python-lsp-server',
			})
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		-- stylua: ignore
		keys = {
			{ '<localleader>w', '<cmd>ObsidianQuickSwitch<CR>' },
			{ '<leader>ff', LazyVim.pick('auto', {prompt_title = "Find Files (Root)"  }), desc = 'Find Files (Root Dir)'  },
			{ '<leader>fg', '<cmd>Telescope git_files<cr>', desc = 'Find Files (git-files)', },
			{ '<localleader>s', '<cmd>Telescope neovim-project history<CR>', desc = 'Sessions' },
		},
		opts = function(_, opts)
			local has_ripgrep = vim.fn.executable('rg') == 1
			local vimgrep_args = opts.defaults.vimgrep_arguments
			local function remove(t, v)
				for i = 1, #t do
					if t[i] == v then
						table.remove(t, i)
						return
					end
				end
			end
			remove(vimgrep_args, '--hidden')
			remove(vimgrep_args, '--follow')
			remove(vimgrep_args, '--no-ignore-vcs')
			remove(vimgrep_args, '--glob')
			remove(vimgrep_args, '!**/.git/*')
			opts.defaults.vimgrep_arguments = vim.tbl_extend(
				'force',
				opts.defaults.vimgrep_arguments,
				has_ripgrep and vimgrep_args or nil
			)
		end,
	},

	-----------------------------------------------------------------------------
	{ 'folke/persistence.nvim', enabled = false },
	{
		'thecontinium/neovim-project',
		-- name = 'neovim-project',
		-- dev = true,
		opts = {
			projects = { -- define project roots
				'~/dev/thecontinium/*',
				'~/dev/mn-dimension/*',
				'~/.config/*',
			},
			-- Overwrite some of Session Manager options
			session_manager_opts = {
				autosave_ignore_dirs = {
					vim.fn.expand('~'), -- don't create a session for $HOME/
					'/tmp',
				},
				autosave_ignore_filetypes = {
					-- All buffers of these file types will be closed before the session is saved
					'ccc-ui',
					'gitcommit',
					'gitrebase',
					'qf',
					'toggleterm',
					'NeogitStatus',
				},
			},
		},
		init = function()
			-- enable saving the state of plugins in the session
			-- vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		end,
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
			{ 'Shatur/neovim-session-manager' },
		},
		lazy = false,
		priority = 100,
	},
	-- {
	-- 	'thecontinium/possession.nvim',
	-- 	event = 'VimEnter',
	-- 	dependencies = { 'nvim-lua/plenary.nvim' },
	-- 	config = function(_, _)
	-- 		require('possession').setup({
	-- 			autoload = function()
	-- 				local name = vim.fn.fnamemodify(LazyVim.root(), ':t:s?^\\.??')
	-- 				if require('possession.paths').session(name):exists() then
	-- 					return name
	-- 				end
	-- 				return 'last_cwd'
	-- 			end,
	-- 			plugins = {
	-- 				neo_tree = false,
	-- 				close_windows = false,
	-- 				delete_hidden_buffers = false,
	-- 				delete_buffers = true,
	-- 			},
	-- 			autosave = {
	-- 				current = true, -- or fun(name): boolean
	-- 			},
	-- 		})
	-- 		require('telescope').load_extension('possession')
	-- 	end,
	-- 	init = function()
	-- 		vim.keymap.set(
	-- 			'n',
	-- 			'<localLeader>s',
	-- 			'<cmd>Telescope possession list<CR>',
	-- 			{ desc = 'Session' }
	-- 		)
	-- 	end,
	-- },
	-- 	{
	-- 		'olimorris/persisted.nvim',
	-- 		event = 'VimEnter',
	-- 		priority = 1000,
	-- 		opts = {
	-- 			autoload = true,
	-- 			follow_cwd = false,
	-- 			ignored_dirs = { '/usr', '/opt', '~/.cache', vim.env.TMPDIR or '/tmp' },
	-- 		},
	-- 		keys = {
	-- 			{
	-- 				'<localLeader>s',
	-- 				'<cmd>Telescope persisted<cr>',
	-- 				desc = 'Telescope session',
	-- 			},
	-- 		},
	-- 		config = function(_, opts)
	-- 			if vim.g.in_pager_mode or vim.env.GIT_EXEC_PATH ~= nil then
	-- 				-- Do not autoload if stdin has been provided, or git commit session.
	-- 				opts.autoload = false
	-- 				opts.autosave = false
	-- 			end
	-- 			require('persisted').setup(opts)
	-- 		end,
	-- 		init = function()
	-- 			require('telescope').load_extension('persisted')
	-- 			-- Detect if stdin has been provided.
	-- 			vim.g.in_pager_mode = false
	-- 			vim.api.nvim_create_autocmd('StdinReadPre', {
	-- 				group = vim.api.nvim_create_augroup('rafi_persisted', {}),
	-- 				callback = function()
	-- 					vim.g.in_pager_mode = true
	-- 				end,
	-- 			})
	-- 			-- Close all floats before loading a session. (e.g. Lazy.nvim)
	-- 			vim.api.nvim_create_autocmd('User', {
	-- 				group = 'rafi_persisted',
	-- 				pattern = 'PersistedLoadPre',
	-- 				callback = function()
	-- 					for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
	-- 						if vim.api.nvim_win_get_config(win).zindex then
	-- 							vim.api.nvim_win_close(win, false)
	-- 						end
	-- 					end
	-- 				end,
	-- 			})
	-- 			-- Close all plugin owned buffers before saving a session.
	-- 			vim.api.nvim_create_autocmd('User', {
	-- 				pattern = 'PersistedSavePre',
	-- 				group = 'rafi_persisted',
	-- 				callback = function()
	-- 					-- Detect if window is owned by plugin by checking buftype.
	-- 					local current_buffer = vim.api.nvim_get_current_buf()
	-- 					for _, win in ipairs(vim.fn.getwininfo()) do
	-- 						local buftype = vim.bo[win.bufnr].buftype
	-- 						if buftype ~= '' and buftype ~= 'help' then
	-- 							-- Delete plugin owned window buffers.
	-- 							if win.bufnr == current_buffer then
	-- 								-- Jump to previous window if current window is not a real file
	-- 								vim.cmd.wincmd('p')
	-- 							end
	-- 							vim.api.nvim_buf_delete(win.bufnr, {})
	-- 						end
	-- 					end
	-- 				end,
	-- 			})
	-- 			-- Before switching to a different session using Telescope, save and stop
	-- 			-- current session to avoid previous session to be overwritten.
	-- 			vim.api.nvim_create_autocmd('User', {
	-- 				pattern = 'PersistedTelescopeLoadPre',
	-- 				group = 'rafi_persisted',
	-- 				callback = function()
	-- 					require('persisted').save()
	-- 					require('persisted').stop()
	-- 				end,
	-- 			})
	-- 			-- After switching to a different session using Telescope, start it so it
	-- 			-- will be auto-saved.
	-- 			vim.api.nvim_create_autocmd('User', {
	-- 				pattern = 'PersistedTelescopeLoadPost',
	-- 				group = 'rafi_persisted',
	-- 				callback = function(session)
	-- 					require('persisted').start()
	-- 					print('Started session ' .. session.data.name)
	-- 				end,
	-- 			})
	-- 		end,
	-- 	},
	{
		'nvim-telescope/telescope.nvim',
		keys = {
			{ '<localleader>w', '<cmd>ObsidianQuickSwitch<CR>' },
		},
		opts = function(_, opts)
			local has_ripgrep = vim.fn.executable('rg') == 1
			local vimgrep_args = opts.defaults.vimgrep_arguments
			local function remove(t, v)
				for i = 1, #t do
					if t[i] == v then
						table.remove(t, i)
						return
					end
				end
			end
			remove(vimgrep_args, '--hidden')
			remove(vimgrep_args, '--follow')
			remove(vimgrep_args, '--no-ignore-vcs')
			remove(vimgrep_args, '--glob')
			remove(vimgrep_args, '!**/.git/*')
			opts.defaults.vimgrep_arguments = vim.tbl_extend(
				'force',
				opts.defaults.vimgrep_arguments,
				has_ripgrep and vimgrep_args or nil
			)
		end,
	},

	-----------------------------------------------------------------------------
	{ 'folke/persistence.nvim', enabled = false },
	{
		'coffebar/neovim-project',
		-- name = 'neovim-project',
		-- dev = true,
		opts = {
			projects = { -- define project roots
				'~/dev/thecontinium/*',
				'~/dev/thecontinium/geniuslabs-ai/MachX/',
				'~/dev/mn-dimension/*',
				'~/.config/nvim',
				'~/.config/',
			},
			-- Overwrite some of Session Manager options
			session_manager_opts = {
				autosave_ignore_dirs = {
					vim.fn.expand('~'), -- don't create a session for $HOME/
					'/tmp',
				},
				autosave_ignore_filetypes = {
					-- All buffers of these file types will be closed before the session is saved
					'ccc-ui',
					'gitcommit',
					'gitrebase',
					'qf',
					'toggleterm',
					'NeogitStatus',
				},
			},
		},
		init = function()
			vim.keymap.set(
				'n',
				'<localLeader>s',
				'<cmd>Telescope neovim-project history<CR>',
				{ desc = 'Sessions' }
			)
			-- enable saving the state of plugins in the session
			-- vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		end,
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
			{ 'Shatur/neovim-session-manager' },
		},
		lazy = false,
		priority = 100,
	},

	-----------------------------------------------------------------------------
	{
		'hrsh7th/nvim-cmp',

		opts = function(_, opts)
			local formatting = {
				format = function(entry, item)
					-- Prepend with a fancy icon from config.
					local icons = LazyVim.config.icons
					if entry.source.name == 'git' then
						item.kind = icons.misc.git
					else
						local icon = icons.kinds[item.kind]
						if icon ~= nil then
							item.kind = icon .. item.kind
						end
					end
					local widths = {
						abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
						menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
					}

					for key, width in pairs(widths) do
						if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
							item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
						end
					end
					item.menu = ({
						buffer = '[Buffer]',
						nvim_lsp = '[LSP]',
						nvim_lua = '[Lua]',
						latex_symbols = '[LaTeX]',
						tmux = '[Tmux]',
						path = '[Path]',
						emoji = '[Emoji]',
						conjure = '[Conjure]',
						obsidian = '[Obsidian]',
						obsidian_new = '[Obsidian]',
						git = '[Git]',
						snippets = '',
					})[entry.source.name]
					if item.menu == nil then
						vim.notify(
							'Unknown source ' .. entry.source.name .. 'Correct in coding.lua'
						)
					end
					return item
				end,
			}
			opts.formatting = vim.tbl_extend('force', opts.formatting, formatting)
		end,
	},
}
