-- Markdown injection for Python %% [markdown] cells
-- Save this as ~/.config/nvim/lua/utils/markdown_injection.lua

---@class MarkdownInjection
---@field debug boolean Debug mode flag
---@field show_ranges function Show detected markdown ranges
---@field toggle_debug function Toggle debug mode
---@field force_update function Force update injection
local M = {}

-- Debug mode flag
M.debug = false

---@type table<integer, {[1]: integer, [2]: integer}[]>
-- Cache for markdown ranges per buffer (bufnr -> array of {start_line, end_line})
local markdown_ranges_cache = {}

---Print debug message if debug mode is enabled
---@param msg string The message to print
local function debug_print(msg)
  if M.debug then
    print("[MarkdownInjection] " .. msg)
  end
end

---Find markdown cell ranges in buffer
---@param bufnr integer Buffer number
---@return {[1]: integer, [2]: integer}[] Array of {start_line, end_line} ranges
local function get_markdown_ranges(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local ranges = {}
  local in_markdown = false
  local region_start = nil

  for i, line in ipairs(lines) do
    local line_num = i - 1

    if line:match("^#%s*%%%%+%s*%[markdown%]") then
      debug_print(string.format("Found markdown marker at line %d", line_num))
      in_markdown = true
      region_start = line_num + 1
    elseif in_markdown then
      if not line:match("^#") then
        if region_start then
          debug_print(string.format("Markdown region: lines %d-%d", region_start, line_num - 1))
          table.insert(ranges, { region_start, line_num - 1 })
        end
        in_markdown = false
        region_start = nil
      end
    end
  end

  if in_markdown and region_start then
    debug_print(string.format("Markdown region (end of file): lines %d-%d", region_start, #lines - 1))
    table.insert(ranges, { region_start, #lines - 1 })
  end

  debug_print(string.format("Total markdown regions found: %d", #ranges))
  return ranges
end

---Custom predicate function to check if a comment is in a markdown cell
---@param match table The match object
---@param pattern string The pattern being matched
---@param bufnr integer Buffer number
---@param predicate table The predicate details
---@param metadata table|nil Additional metadata
---@return boolean True if comment is in markdown cell
local function in_markdown_cell(match, pattern, bufnr, predicate, metadata)
  debug_print(string.format("Predicate called for buffer %d", bufnr))

  -- Get cached ranges for this buffer
  local ranges = markdown_ranges_cache[bufnr]
  if not ranges or #ranges == 0 then
    debug_print("No cached ranges found")
    return false
  end

  debug_print(string.format("Checking against %d ranges", #ranges))

  -- Get the capture (the comment node)
  local capture_id = predicate[2]
  local nodes = match[capture_id]

  if not nodes or #nodes == 0 then
    debug_print("No nodes in match")
    return false
  end

  local node = nodes[1]
  local start_row = node:range()

  debug_print(string.format("Comment at row %d", start_row))

  -- Check if this row is in any markdown range
  for _, range in ipairs(ranges) do
    if start_row >= range[1] and start_row <= range[2] then
      debug_print(string.format("Row %d is in range [%d-%d] - MATCH!", start_row, range[1], range[2]))
      return true
    end
  end

  debug_print(string.format("Row %d not in any range", start_row))
  return false
end

---Update markdown ranges and reparse buffer
---@param bufnr? integer Buffer number (defaults to current buffer)
local function update_injection(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  debug_print(string.format("Updating injection for buffer %d", bufnr))

  -- Update cached ranges
  markdown_ranges_cache[bufnr] = get_markdown_ranges(bufnr)

  -- Force treesitter to reparse
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "python")
  if ok and parser then
    debug_print("Invalidating parser and scheduling reparse")
    parser:invalidate(true)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        pcall(parser.parse, parser)
        debug_print("Reparse completed")
      end
    end)
  else
    debug_print("Failed to get parser")
  end
end

---Show markdown ranges in current buffer
function M.show_ranges()
  local bufnr = vim.api.nvim_get_current_buf()
  local ranges = markdown_ranges_cache[bufnr]
  if not ranges or #ranges == 0 then
    print("No markdown ranges found in current buffer")
  else
    print(string.format("Markdown ranges in buffer %d:", bufnr))
    for i, range in ipairs(ranges) do
      print(string.format("  %d: lines %d-%d", i, range[1], range[2]))
    end
  end
end

---Toggle debug mode
function M.toggle_debug()
  M.debug = not M.debug
  print("Markdown injection debug mode: " .. (M.debug and "ON" or "OFF"))
end

---Force update injection for current buffer
function M.force_update()
  local bufnr = vim.api.nvim_get_current_buf()
  print("Forcing update for buffer " .. bufnr)
  update_injection(bufnr)
end

---Setup markdown injection for Python files
function M.setup()
  -- Register the custom predicate FIRST
  vim.treesitter.query.add_predicate("in-markdown-cell?", in_markdown_cell, { force = true })
  debug_print("Registered custom predicate: in-markdown-cell?")

  -- Set the injection query directly
  local query_content = [[
; Inject markdown into comments within markdown cells
((comment) @injection.content
 (#in-markdown-cell? @injection.content)
 (#set! injection.language "markdown")
 (#offset! @injection.content 0 1 0 0))
]]

  -- Set the query directly
  local ok, err = pcall(vim.treesitter.query.set, "python", "injections", query_content)
  if not ok then
    vim.notify("Failed to set injection query: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  debug_print("Set injection query for python")
  update_injection()
  -- Setup autocommands
  local group = vim.api.nvim_create_augroup("MarkdownInjection", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function(args)
      debug_print("FileType python triggered")
      update_injection(args.buf)

      -- Setup buffer-local autocommands for updates
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = group,
        buffer = args.buf,
        callback = function()
          debug_print("BufWritePost triggered")
          update_injection(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
        group = group,
        buffer = args.buf,
        callback = function()
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              debug_print("TextChanged triggered")
              update_injection(args.buf)
            end
          end, 150)
        end,
      })

      vim.api.nvim_create_autocmd("BufDelete", {
        group = group,
        buffer = args.buf,
        callback = function()
          markdown_ranges_cache[args.buf] = nil
        end,
      })
    end,
  })

  -- Initialize current buffer
  if vim.bo.filetype == "python" then
    vim.defer_fn(function()
      debug_print("Initializing current buffer")
      update_injection()
    end, 100)
  end

  vim.notify("Markdown injection enabled for Python %% cells", vim.log.levels.INFO)

  -- Verify setup
  vim.defer_fn(function()
    local q = vim.treesitter.query.get("python", "injections")
    debug_print("Query loaded: " .. (q and "YES" or "NO"))
  end, 200)
end

return M
