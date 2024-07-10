return {
	{ import = 'lazyvim.plugins.extras.coding.yanky' },
	{ import = 'rafi.plugins.extras.coding.align' },
	{ import = 'rafi.plugins.extras.editor.harpoon2' },

	{ import = 'rafi.plugins.extras.git.cmp-git' },

	{ import = 'lazyvim.plugins.extras.lang.docker' },
	{ import = 'rafi.plugins.extras.lang.tmux' },

	{ import = 'lazyvim.plugins.extras.editor.mini-files' },
	{
		'echasnovski/mini.files',
		keys = {
			{
				'<leader>fM',
				function()
					require('mini.files').open(vim.loop.cwd(), true)
				end,
				desc = 'Open mini.files (cwd)',
			},
			{
				'<leader>fm',
				function()
					require('mini.files').open(LazyVim.root(), true)
				end,
				desc = 'Open mini.files (root)',
			},
		},
		opts = {
			mappings = {
				-- go_in_horizontal = '<C-w>s',
				-- go_in_vertical = '<C-w>v',
				go_in_horizontal_plus = 'sv',
				go_in_vertical_plus = 'sg',
			},
			windows = {
				width_nofocus = 20,
				width_focus = 50,
				width_preview = 100,
			},
			options = {
				use_as_default_explorer = true,
			},
		},
	},
}
