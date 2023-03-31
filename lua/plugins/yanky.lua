return {

	{
		"gbprod/yanky.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
			{ "<c-n>", "<Plug>(YankyCycleForward)", mode = { "n", "x" } },
			{ "<c-p>", "<Plug>(YankyCycleBackward)", mode = { "n", "x" } },
			{ "Pc", "<Plug>(YankyPutBeforeCharwiseJoined)", mode = { "n", "x" } },
			{ "pc", "<Plug>(YankyPutAfterCharwiseJoined)", mode = { "n", "x" } },
			{ "Pl", "<Plug>(YankyPutBeforeLinewiseJoined)", mode = { "n", "x" } },
			{ "pl", "<Plug>(YankyPutAfterLinewiseJoined)", mode = { "n", "x" } },
			{ "<localleader>y", "<cmd>Telescope yank_history<CR>", mode = { "n", "x" }, desc = "Telescope yanky" },
		},
		config = function()
			local utils = require("yanky.utils")
			local mapping = require("yanky.telescope.mapping")
			local yanky = require("yanky")
			yanky.setup({
				ring = {
					history_length = 100,
					storage = "sqlite",
					sync_with_numbered_registers = true,
					cancel_event = "update",
				},
				system_clipboard = {
					sync_with_ring = true,
				},
				highlight = {
					on_put = false,
					on_yank = false,
					timer = 500,
				},
				picker = {
					telescope = {
						mappings = {
							default = mapping.put("p"),
							i = {
								["<c-p>"] = mapping.put("p"),
								["<c-k>"] = mapping.put("P"),
								["<c-x>"] = mapping.delete(),
								["<c-r>"] = mapping.set_register(utils.get_default_register()),
								["<c-c>"] = mapping.special_put("YankyPutAfterCharwiseJoined"),
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								r = mapping.set_register(utils.get_default_register()),
								c = mapping.special_put("YankyPutAfterCharwiseJoined"),
							},
						},
					},
				},
			})
			require("telescope").load_extension("yank_history")
		end,
	},
}
