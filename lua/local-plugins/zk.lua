require("zk").setup({
  -- create user commands such as :ZkNew
  create_user_commands = true,

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      -- init_options = ...
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
})

require("telescope").load_extension("zk")

-- Create notes / links

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>kc",
  "<cmd>lua require('zk').new()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "x",
  "<LocalLeader>kc",
  "<esc><cmd>lua require('zk').new_link()<CR>",
  { noremap = true }
)

-- Show Telescope pickers

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>kn",
  "<cmd>lua require('telescope').extensions.zk.notes()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>ko",
  "<cmd>lua require('telescope').extensions.zk.orphans()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>kb",
  "<cmd>lua require('telescope').extensions.zk.backlinks()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>kl",
  "<cmd>lua require('telescope').extensions.zk.links()<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>kt",
  "<cmd>lua require('telescope').extensions.zk.tags()<CR>",
  { noremap = true }
)
