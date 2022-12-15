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

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

vim.keymap.set({ "n", "x" }, "Pc", "<Plug>(YankyPutBeforeCharwiseJoined)")
vim.keymap.set({ "n", "x" }, "pc", "<Plug>(YankyPutAfterCharwiseJoined)")
vim.keymap.set({ "n", "x" }, "Pl", "<Plug>(YankyPutBeforeLinewiseJoined)")
vim.keymap.set({ "n", "x" }, "pl", "<Plug>(YankyPutAfterLinewiseJoined)")
require("telescope").load_extension("yank_history")
vim.keymap.set("n", "<localleader>y", "<cmd>Telescope yank_history<CR>")

