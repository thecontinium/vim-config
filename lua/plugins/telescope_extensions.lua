return {
	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<localLeader>p", "<cmd>Telescope undo<cr>", desc = "Telescope undo", },
		},
		config = function()
			require("telescope").load_extension("undo")
			-- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
		end,
	},

	{
		"LukasPietzschmann/telescope-tabs",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<localLeader><tab>", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Telescope tabs", },
		},
		config = function()
			require("telescope-tabs").setup({
				close_tab_shortcut_i = "<C-d>", -- if you're in insert mode
				close_tab_shortcut_n = "dd", -- if you're in normal mode
			})
		end,
	},
}
