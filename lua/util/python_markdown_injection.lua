-- Optimized Markdown injection for Python %% [markdown] cells
-- Save this as ~/.config/nvim/lua/utils/markdown_injection.lua

---@class MarkdownInjection
---@field debug boolean Debug mode flag
---@field show_ranges function Show detected markdown ranges
---@field toggle_debug function Toggle debug mode
---@field force_update function Force update injection
---@field enabled boolean Whether markdown injection is enabled
---@field toggle snacks.toggle.Class|nil Snacks toggle instance
local M = {}

M.debug = false
M.enabled = false

---@type table<integer, {[1]: integer, [2]: integer, version: integer}[]>
local markdown_ranges_cache = {}

---@type table<integer, integer>
local buffer_versions = {}

---Print debug message if debug mode is enabled
---@param msg string The message to print
local function debug_print(msg)
  if M.debug then
    print("[MarkdownInjection] " .. msg)
  end
end

---Get buffer version for change detection
---@param bufnr integer Buffer number
---@return integer Buffer changedtick
local function get_buffer_version(bufnr)
  return vim.api.nvim_buf_get_changedtick(bufnr)
end

---Find markdown cell ranges in buffer (optimized)
---@param bufnr integer Buffer number
---@return {[1]: integer, [2]: integer}[] Array of {start_line, end_line} ranges
local function get_markdown_ranges(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local ranges = {}
  local in_markdown = false
  local region_start = nil
  local line_count = #lines

  for i = 1, line_count do
    local line = lines[i]
    local line_num = i - 1

    -- Fast path: check first character before expensive pattern match
    if line:byte(1) == 35 then -- '#' character
      if in_markdown then
        -- Already in markdown, continue
      else
        -- Check for markdown marker
        if line:match("^#%s*%%%%+%s*%[markdown%]") then
          debug_print(string.format("Found markdown marker at line %d", line_num))
          in_markdown = true
          region_start = line_num + 1
        end
      end
    elseif in_markdown then
      -- Non-comment line ends the region
      if region_start and region_start <= line_num - 1 then
        debug_print(string.format("Markdown region: lines %d-%d", region_start, line_num - 1))
        ranges[#ranges + 1] = { region_start, line_num - 1 }
      end
      in_markdown = false
      region_start = nil
    end
  end

  -- Handle region extending to EOF
  if in_markdown and region_start and region_start <= line_count - 1 then
    debug_print(string.format("Markdown region (end of file): lines %d-%d", region_start, line_count - 1))
    ranges[#ranges + 1] = { region_start, line_count - 1 }
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
  -- Get cached ranges for this buffer
  local ranges = markdown_ranges_cache[bufnr]
  if not ranges or #ranges == 0 then
    return false
  end

  -- Get the capture (the comment node)
  local capture_id = predicate[2]
  local nodes = match[capture_id]

  if not nodes or #nodes == 0 then
    return false
  end

  local node = nodes[1]
  local start_row = node:range()

  -- Binary search for performance with many ranges
  if #ranges > 10 then
    local left, right = 1, #ranges
    while left <= right do
      local mid = math.floor((left + right) / 2)
      local range = ranges[mid]

      if start_row < range[1] then
        right = mid - 1
      elseif start_row > range[2] then
        left = mid + 1
      else
        return true
      end
    end
    return false
  end

  -- Linear search for small number of ranges
  for i = 1, #ranges do
    local range = ranges[i]
    if start_row >= range[1] and start_row <= range[2] then
      return true
    end
  end

  return false
end

---Update markdown ranges and reparse buffer
---@param bufnr? integer Buffer number (defaults to current buffer)
local function update_injection(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Skip if disabled
  if not M.enabled then
    debug_print(string.format("Markdown injection disabled, skipping update for buffer %d", bufnr))
    return
  end

  -- Check if buffer has changed
  local current_version = get_buffer_version(bufnr)
  if buffer_versions[bufnr] == current_version then
    debug_print(string.format("Buffer %d unchanged, skipping update", bufnr))
    return
  end

  debug_print(string.format("Updating injection for buffer %d", bufnr))

  -- Update cached ranges
  markdown_ranges_cache[bufnr] = get_markdown_ranges(bufnr)
  buffer_versions[bufnr] = current_version

  -- Force treesitter to reparse
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "python")
  if ok and parser then
    debug_print("Invalidating parser")
    parser:invalidate(true)
    -- Reparse is now synchronous for immediate effect
    pcall(parser.parse, parser)
    debug_print("Reparse completed")
  else
    debug_print("Failed to get parser")
  end
end

---Write injection query to file if it doesn't exist and register it manually
local function ensure_injection_file()
  local config_path = vim.fn.stdpath("config")
  local query_dir = config_path .. "/queries/python"
  local query_file = query_dir .. "/injections.scm"

  local query_content = [[; Inject markdown into comments within markdown cells
((comment) @injection.content
 (#in-markdown-cell? @injection.content)
 (#set! injection.language "markdown")
 (#offset! @injection.content 0 1 0 0))
]]

  -- Check if file already exists
  if vim.fn.filereadable(query_file) == 1 then
    debug_print("Using existing injection query file: " .. query_file)
    return
  end

  -- Create directory if it doesn't exist
  vim.fn.mkdir(query_dir, "p")

  -- Write the injection query
  local file = io.open(query_file, "w")
  if not file then
    vim.notify("Failed to create injection query file: " .. query_file, vim.log.levels.ERROR)
    return
  end

  file:write(query_content)
  file:close()

  debug_print("Created injection query file: " .. query_file)
  vim.notify("Created Python markdown injection query at: " .. query_file, vim.log.levels.INFO)

  -- Manually register the query since file was just created
  local ok, err = pcall(vim.treesitter.query.set, "python", "injections", query_content)
  if not ok then
    vim.notify("Failed to set injection query: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  debug_print("Manually set injection query for python (file was just created)")
end

---Show markdown ranges in current buffer
function M.show_ranges()
  local bufnr = vim.api.nvim_get_current_buf()
  local ranges = markdown_ranges_cache[bufnr]
  if not ranges or #ranges == 0 then
    print("No markdown ranges found in current buffer")
  else
    print(string.format("Markdown ranges in buffer %d:", bufnr))
    for i = 1, #ranges do
      local range = ranges[i]
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
  buffer_versions[bufnr] = nil -- Force update
  update_injection(bufnr)
end

---Setup markdown injection for Python files
function M.setup()
  -- Ensure the injection query file exists and register if needed
  ensure_injection_file()

  -- Register the custom predicate
  vim.treesitter.query.add_predicate("in-markdown-cell?", in_markdown_cell, { force = true })
  debug_print("Registered custom predicate: in-markdown-cell?")

  -- Setup autocommands
  local group = vim.api.nvim_create_augroup("MarkdownInjection", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function(args)
      debug_print("FileType python triggered")
      update_injection(args.buf)

      -- Debounced updates: waits 200ms after last change before updating
      -- This prevents running expensive operations on every keystroke
      local timer = nil
      local function debounced_update()
        -- Cancel pending update if one exists
        if timer then
          timer:stop()
        end
        -- Schedule new update 200ms from now
        timer = vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            debug_print("Debounced update triggered")
            update_injection(args.buf)
          end
          timer = nil
        end, 200)
      end

      -- Trigger debounced update on any text change
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
        group = group,
        buffer = args.buf,
        callback = debounced_update,
      })

      -- Immediate update on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        buffer = args.buf,
        callback = function()
          debug_print("BufWritePost triggered")
          update_injection(args.buf)
        end,
      })

      -- Cleanup on buffer delete
      vim.api.nvim_create_autocmd("BufDelete", {
        group = group,
        buffer = args.buf,
        callback = function()
          markdown_ranges_cache[args.buf] = nil
          buffer_versions[args.buf] = nil
        end,
      })
    end,
  })

  -- Initialize current buffer if it's Python
  if vim.bo.filetype == "python" then
    vim.defer_fn(function()
      debug_print("Initializing current buffer")
      update_injection()
    end, 100)
  end

  -- Create Snacks.toggle if available
  local has_snacks, snacks = pcall(require, "snacks")
  if has_snacks and snacks.toggle then
    M.toggle = snacks.toggle({
      name = "Python Markdown Injection",
      get = function()
        return M.enabled
      end,
      set = function(state)
        M.enabled = state
        if state then
          -- Re-enable: update all python buffers
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "python" then
              buffer_versions[buf] = nil -- Force update
              update_injection(buf)
            end
          end
        else
          -- Disable: clear caches and reparse to remove injections
          for bufnr, _ in pairs(markdown_ranges_cache) do
            markdown_ranges_cache[bufnr] = {}
            local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "python")
            if ok and parser then
              parser:invalidate(true)
              pcall(parser.parse, parser)
            end
          end
        end
      end,
    })

    -- Optionally map to a keymap
    M.toggle:map("<leader>um") -- Uncomment and customize keymap as needed

    debug_print("Markdown injection enabled with Snacks toggle")
  else
    debug_print("Markdown injection enabled for Python %% cells")
  end
end

return M
