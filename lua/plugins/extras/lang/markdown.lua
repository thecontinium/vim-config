return {
	{ import = 'rafi.plugins.extras.lang.markdown' },
	{
		'mfussenegger/nvim-lint',
		optional = true,
		opts = {
			linters = {
				['markdownlint-cli2'] = {
					args = {
						'--config',
						vim.fn.expand('~/.config/markdownlint/.markdownlint.jsonc'),
						'--',
					},
				},
			},
		},
	},

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
}
