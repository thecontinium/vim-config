return {
	{
		'nvim-lualine/lualine.nvim',
		opts = function(_, opts)
			opts.sections.lualine_b[2] = LazyVim.lualine.root_dir({ cwd = true })
		end,
	},
}
