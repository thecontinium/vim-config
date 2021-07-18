require("zk").setup({
  debug = false,
  log = true,
  default_keymaps = true,
  default_notebook_path = vim.env.ZK_NOTEBOOK_DIR or "",
  fuzzy_finder = "fzf", -- or "telescope"
  link_format = "markdown" -- or "wiki"
})

local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')

configs.zk = {
  default_config = {
    cmd = {'zk', 'lsp'},
    filetypes = {'markdown'},
    root_dir = function()
      return vim.loop.cwd()
    end,
    settings = {}
  };
}

lspconfig.zk.setup({ on_attach = function(client, buffer) 
  -- Add keybindings here, see https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
end })
