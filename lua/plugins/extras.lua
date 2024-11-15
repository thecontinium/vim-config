local util = require('lspconfig.util')
return {
	{ import = 'lazyvim.plugins.extras.coding.yanky' },
	{ import = 'rafi.plugins.extras.coding.align' },
	{ import = 'rafi.plugins.extras.editor.harpoon2' },
	{ import = 'rafi.plugins.extras.git.cmp-git' },

	{ import = 'lazyvim.plugins.extras.ai.codeium' },
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

	{ import = 'rafi.plugins.extras.lang.markdown' },
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {
        code = {
        highlight = 'htmlUnderline',
				disable_background = true,
				border = 'thick',
				position = 'right',
				width = 'block',
				right_pad = 10,
				left_pad = 2,
				sign = false,
			},
		},
	},

	{
		'mfussenegger/nvim-lint',
		optional = true,
		opts = {
			linters = {
				['markdownlint-cli2'] = {
					args = { '--config', vim.fn.expand("~/.config/markdownlint/.markdownlint.jsonc"), '--' }
				},
			},
		},
		keys = {
			{
				'<leader>cin',
				function()
					vim.notify(vim.inspect(require('lint')._resolve_linter_by_ft(vim.bo.filetype)))
				end,
				silent = true,
				desc = 'Linter Info',
			},
		},
	},

	{ import = 'lazyvim.plugins.extras.editor.mini-files' },
}
