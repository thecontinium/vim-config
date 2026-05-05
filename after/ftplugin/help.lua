-- Help utilities
--

if vim.bo.buftype ~= "help" then
  return
end

-- Count the number of file windows in current tabpage.
---@return integer
local function count_windows()
  local win_count = 0
  local tab_windows = vim.api.nvim_tabpage_list_wins(0)
  for _, winnr in ipairs(tab_windows) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if vim.bo[bufnr].buftype == "" then
      win_count = win_count + 1
    end
  end
  return win_count
end

vim.opt_local.spell = false
vim.opt_local.list = false

if count_windows() > 2 then
  vim.cmd.wincmd("K")
else
  vim.cmd.wincmd("L")
end

-- Key-mappings
local function map(mode, lhs, rhs, base_opts, desc)
  local opts = vim.tbl_extend("force", base_opts, { desc = desc })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local opts = { remap = true, buffer = 0 }
map("n", "<CR>", "<C-]>", opts, "Follow help tag under cursor")
map("n", "<BS>", "<C-T>", opts, "Jump back to previous help location")
map("n", "<Leader>o", "gO", opts, "Open location list of help headings")

opts = { silent = true, buffer = 0 }
map("n", "<Tab>", "/'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts, "Jump to next help option (word in quotes)")
map("n", "<S-Tab>", "?'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts, "Jump to previous help option (word in quotes)")
map("n", "o", "/|\\S\\+|<CR>:nohlsearch<CR>", opts, "Jump to next help tag (word in pipes)")
map("n", "O", "h?|\\S\\+|<CR>:nohlsearch<CR>", opts, "Jump to previous help tag (word in pipes)")
map("n", "p", "/\\*\\S\\+\\*<CR>:nohlsearch<CR>", opts, "Jump to next help subject (word in asterisks)")
map("n", "P", "h?\\*\\S\\+\\*<CR>:nohlsearch<CR>", opts, "Jump to previous help subject (word in asterisks)")

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
  .. "\n "
  .. "setlocal spell< list<"
  .. " | sil! nunmap <buffer> <CR>"
  .. " | sil! nunmap <buffer> <BS>"
  .. " | sil! nunmap <buffer> <Leader>o"
  .. " | sil! nunmap <buffer> <Tab>"
  .. " | sil! nunmap <buffer> <S-Tab>"
  .. " | sil! nunmap <buffer> o"
  .. " | sil! nunmap <buffer> O"
  .. " | sil! nunmap <buffer> p"
  .. " | sil! nunmap <buffer> P"
