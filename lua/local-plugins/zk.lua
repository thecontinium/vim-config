require("zk").setup({
  debug = false,
  log = true,
  default_keymaps = true,
  default_notebook_path = vim.env.ZK_NOTEBOOK_DIR or "",
  fuzzy_finder = "fzf", -- or "telescope"
  link_format = "markdown" -- or "wiki"
})
require("zk").setup_keymaps()

local function map(mode, lhs, rhs, opts)
  local map_opts = {noremap = true, silent = true, expr = false}
  opts = vim.tbl_extend("force", map_opts, opts or {})
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
-- telescope-zettelkasten
function _G.search_zettel()
  require("telescope.builtin").find_files {
    prompt_title = "Search ZK",
    hidden = true,
    shorten_path = false,
    cwd = vim.env.ZK_NOTEBOOK_DIR or "",
  }
end
require('telescope').load_extension('zk')
map("n", "<leader>zf", "<cmd>lua _G.search_zettel()<cr>")
map("n", "<leader>zn", "<cmd>lua require('telescope').extensions.zk.zk_notes()<cr>")
map("n", "<leader>zg", "<cmd>lua require('telescope').extensions.zk.zk_grep()<cr>")
map("n", "<leader>zb", "<cmd>lua require('telescope').extensions.zk.zk_backlinks()<cr>")

-- 
-- local lspconfig = require('lspconfig')
-- local configs = require('lspconfig/configs')
-- 
-- configs.zk = {
--   default_config = {
--     cmd = {'zk', 'lsp'},
--     filetypes = {'markdown'},
--     root_dir = function()
--       return vim.loop.cwd()
--     end,
--     settings = {}
--   };
-- }
-- 
-- lspconfig.zk.setup({ on_attach = function(client, buffer) 
--   -- Add keybindings here, see https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
-- end })
