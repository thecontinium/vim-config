return {
	{
		'lukas-reineke/indent-blankline.nvim',
		version = '2.20.8',
	},
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v3.x",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = (vim.list_extend(opts.ensure_installed, {'clojure'}))
		end,
	},
	{
		"mickael-menu/zk-nvim",
		keys = {
			{ "<leader>zd", "<Cmd>ZkNew {  dir=vim.env.ZK_NOTEBOOK_DIR .. '/journal/daily' }<CR>", desc = "Zk Diary" },
		},
	},
}
