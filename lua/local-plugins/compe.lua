-- plugin: nvim-compe
-- see: https://github.com/hrsh7th/nvim-compe
-- rafi settings

require('plugins.compe')

require'compe'.setup({
  enabled = true,
  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    orgmode = true,
    tmux = { all_panes = true },
    spell = false,
    calc = false,
    conjure = true,
  },
})

