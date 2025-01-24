return {
	-----------------------------------------------------------------------------
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
				'vim-language-server',
			})
		end,
	},
	-----------------------------------------------------------------------------
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
						codeium = '[Codeium]',
						obsidian = '[Obsidian]',
						obsidian_new = '[Obsidian]',
						git = '[Git]',
						snippets = '',
					})[entry.source.name]
					if item.menu == nil then
						vim.notify(
							'Unknown source '
								.. entry.source.name
								.. ' Correct in extend-rafi.lua'
						)
					end
					return item
				end,
			}
			opts.formatting = vim.tbl_extend('force', opts.formatting, formatting)
		end,
	},
}
