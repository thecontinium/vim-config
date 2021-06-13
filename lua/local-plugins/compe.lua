-- plugin: nvim-compe
-- see: https://github.com/hrsh7th/nvim-compe
-- rafi settings

require('plugins.compe')

require'compe'.setup({
  enabled = true,
  source = {
    path = true,
    buffer = true,
    spell = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    conjure = true,
    -- tmux = true,
    -- tmux = { all_panes = true }
  },
})

