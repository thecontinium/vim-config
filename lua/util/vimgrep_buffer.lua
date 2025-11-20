local M = {}

-- local helper: vimgrep for current buffer only
local function vimgrep_in_buffer(patterns)
  local fname = vim.fn.expand("%")

  if not patterns then
    vim.notify("No pattern provided")
    return
  end

  -- Normalize: allow string or table of strings
  if type(patterns) == "string" then
    patterns = { patterns }
  end

  -- clear loclist before populating
  vim.fn.setloclist(0, {}, "r")

  for _, pat in ipairs(patterns) do
    if pat and pat ~= "" then
      -- escape slashes so pattern is safe inside /.../
      local escaped = pat:gsub("/", "\\/")

      vim.cmd("lvimgrepadd /" .. escaped .. "/gj " .. fname)
    end
  end

  vim.cmd("Trouble loclist")
end

-- public: grep word under cursor
function M.word()
  local word = vim.fn.expand("<cword>")
  vimgrep_in_buffer(word)
end

-- public: grep TODO (only one pattern here, but table works too)
function M.todo()
  vimgrep_in_buffer("TODO")
end

return M
