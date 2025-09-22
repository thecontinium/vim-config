return {
	{
		'nvim-telescope/telescope.nvim',
		optional = true,
		dependencies = {
			-- Telescope extension for Undo
			{
				'debugloop/telescope-undo.nvim',
				keys = {
					{
						'<localLeader>p',
						'<cmd>Telescope undo<cr>',
						desc = 'Telescope undo',
					},
				},
				config = function()
					require('telescope').load_extension('undo')
					-- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
				end,
			},
			-- Browse tabs
			{
				'LukasPietzschmann/telescope-tabs',
				keys = {
					{
						'<localLeader><tab>',
						'<cmd>Telescope telescope-tabs list_tabs<cr>',
						desc = 'Telescope tabs',
					},
				},
				config = function()
					require('telescope-tabs').setup({
						close_tab_shortcut_i = '<c-d>', -- if you're in insert mode
						close_tab_shortcut_n = 'dd', -- if you're in normal mode
					})
				end,
			},
		},
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
}
