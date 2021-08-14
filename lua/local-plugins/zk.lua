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

map("n", "<leader>zf", "<cmd>lua _G.search_zettel()<cr>")
-- require('telescope').load_extension('zk')
-- map("n", "<leader>zn", "<cmd>lua require('telescope').extensions.zk.zk_notes()<cr>")
-- map("n", "<leader>zg", "<cmd>lua require('telescope').extensions.zk.zk_grep()<cr>")
-- map("n", "<leader>zb", "<cmd>lua require('telescope').extensions.zk.zk_backlinks()<cr>")

local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'

configs.zk = {
  default_config = {
    cmd = {'zk', 'lsp'};
    filetypes = {'markdown'};
    root_dir = lspconfig.util.root_pattern('.zk');
    settings = {};
  };
}

configs.zk.index = function()
  vim.lsp.buf.execute_command({
    command = "zk.index",
    arguments = {vim.api.nvim_buf_get_name(0)},
  })
end

configs.zk.new = function(...)
  vim.lsp.buf_request(0, 'workspace/executeCommand',
    {
        command = "zk.new",
        arguments = {
            vim.api.nvim_buf_get_name(0),
            ...
        },
    },
    function(_, _, result)
      if not (result and result.path) then return end
      vim.cmd("edit " .. result.path)
    end
  )
end

lspconfig.zk.setup({
  on_attach = function(client, bufnr)
    -- Key mappings
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap("n", "<CR>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<leader>zi", ":ZkIndex<CR>", opts)
    buf_set_keymap("v", "<leader>zn", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
    buf_set_keymap("n", "<leader>zn", ":ZkNew {title = vim.fn.input('Title: ')}<CR>", opts)
    buf_set_keymap("n", "<leader>zl", ":ZkNew {dir = 'log'}<CR>", opts)
  end
})
