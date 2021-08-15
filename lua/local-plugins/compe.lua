-- plugin: nvim-compe
-- see: https://github.com/hrsh7th/nvim-compe
-- rafi settings
require('plugins.compe')

require('compe').setup({
    debug = true,
    -- min_length = 1,
    -- preselect = 'enable',
    source = {
        path = true,
        buffer = {kind = '  '}, --     
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = {kind = ' ⮡  (Snippet)'}, -- ⮡
        orgmode = true,
        tmux = {kind = '  ', all_panes = true}, --   
        calc = false,
        spell = {
            kind = ' ', --  
            filetypes = {'mail', 'gitcommit', 'markdown', 'text'}
        },
        conjure = true,
    },
    documentation = {
        border = 'rounded',
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
        winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:UserBorder'
    }
})
