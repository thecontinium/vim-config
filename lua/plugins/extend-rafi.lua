return {
	-- {
	-- 	'lukas-reineke/indent-blankline.nvim',
	-- 	version = '2.20.8',
	-- },
	-- {
	-- 	'nvim-neo-tree/neo-tree.nvim',
	-- 	branch = "v3.x",
	-- },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = (vim.list_extend(opts.ensure_installed, { 'clojure' }))
		end,
	},

  { "mickael-menu/zk-nvim", enabled = false },

	{
		'nvim-telescope/telescope.nvim',
		keys = {
			{ '<localleader>w', '<cmd>ObsidianQuickSwitch<CR>'},
		},
	}
}
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
