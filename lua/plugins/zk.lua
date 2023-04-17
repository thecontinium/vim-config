return {
	{
		"mickael-menu/zk-nvim",
		name = "zk",
		ft = "markdown",
		cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkMatch" },
		keys = {
			{ "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "Zk New" },
			{ "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = "Zk Notes" },
			{ "<leader>zt", "<Cmd>ZkTags<CR>", desc = "Zk Tags" },
			{ "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", desc = "Zk Search", },
			{ "<leader>zf", ":'<,'>ZkMatch<CR>", mode = "x", desc = "Zk Match" },
			{ "<leader>zb", "<Cmd>ZkBacklinks<CR>", desc = "Zk Backlinks" },
			{ "<leader>zl", "<Cmd>ZkLinks<CR>", desc = "Zk Links" },
			{ "<leader>zd", "<Cmd>ZkNew {  dir=vim.env.ZK_NOTEBOOK_DIR .. '/journal/daily' }<CR>", desc = "Zk Diary" },
		},
		opts = { picker = "telescope" },
	},
}
