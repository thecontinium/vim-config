-- Custom pickers
-- Directory Picker
local function directory_picker(opts)
  opts = opts or {}
  local current_dir = opts.cwd or vim.fn.getcwd()
  local source = opts.source or "directories"
  local dirs = {}

  -- Get immediate subdirectories
  local handle = vim.loop.fs_scandir(current_dir)
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end
      if type == "directory" then
        table.insert(dirs, name)
      end
    end
  end

  table.sort(dirs)

  -- Convert to table format
  local items = {}
  for _, dir in ipairs(dirs) do
    local full_path = current_dir .. "/" .. dir
    table.insert(items, { text = dir, value = full_path })
  end

  Snacks.picker.pick({
    source = source,
    items = items,
    layout = { preset = "select" },
    format = "text",
    confirm = function(picker, item)
      picker:close()
      Snacks.notify.info("Changed directory to Lazy Plugin " .. item.text)
      vim.cmd("cd " .. item.value)
    end,
  })
end

-- Tabs Picker
local function get_tabs()
  local tabs = {}
  local tabpages = vim.api.nvim_list_tabpages()
  for i, tabpage in ipairs(tabpages) do
    local wins = vim.api.nvim_tabpage_list_wins(tabpage)
    local cur_win = vim.api.nvim_tabpage_get_win(tabpage)
    local buf = vim.api.nvim_win_get_buf(cur_win)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    if name == "" then
      name = "[No Name]"
    end

    local preview_lines = {}
    table.insert(preview_lines, ("Tab %d: %d window%s"):format(i, #wins, #wins == 1 and "" or "s"))
    table.insert(preview_lines, ("%-6s %-8s %s"):format("WinID", "Buf#", "File"))
    table.insert(preview_lines, string.rep("-", 40))
    for _, win in ipairs(wins) do
      local win_buf = vim.api.nvim_win_get_buf(win)
      local bufname = vim.api.nvim_buf_get_name(win_buf)
      if bufname == "" then
        bufname = "[No Name]"
      end
      bufname = vim.fn.fnamemodify(bufname, ":~:.") -- relative to cwd, or ~
      local win_marker = (win == cur_win) and "->" or "  "
      table.insert(preview_lines, ("%s %-6d %-8d %s"):format(win_marker, win, win_buf, bufname))
    end
    if #wins == 0 then
      table.insert(preview_lines, "No windows in tab")
    end

    table.insert(tabs, {
      idx = i,
      text = ("Tab %d: %s"):format(i, name),
      tabnr = i,
      tabpage = tabpage,
      preview = {
        text = table.concat(preview_lines, "\n"),
        ft = "text",
      },
    })
  end
  return tabs
end

local function tabs_picker()
  local items = get_tabs()
  Snacks.picker({
    title = "Tabs",
    items = items,
    format = "text",
    confirm = function(picker, item)
      picker:close()
      vim.cmd(("tabnext %d"):format(item.tabnr))
    end,
    preview = "preview",
    actions = {
      close_tab = function(picker, item)
        picker:close()
        vim.cmd(("tabclose %d"):format(item.tabnr))
      end,
    },
    win = {
      input = {
        keys = {
          ["d"] = "close_tab",
        },
      },
    },
  })
end

local function list_by_mtime(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()
  cwd = vim.fn.fnamemodify(cwd, ":p")
  local patterns = opts.patterns or nil -- list of glob patterns
  local max_depth = opts.max_depth or nil
  local ret = {}

  local function glob_to_pattern(glob)
    local pattern = glob:gsub("%.", "%%.") -- escape dot
    pattern = pattern:gsub("%*", ".*") -- convert * to .*
    pattern = "^" .. pattern .. "$" -- match whole string
    return pattern
  end
  local function match_patterns(name)
    if not patterns then
      return true
    end
    for _, glob in ipairs(patterns) do
      local pat = glob_to_pattern(glob)
      if name:match(pat) then
        return true
      end
    end
    return false
  end
  local function scan(path, depth)
    depth = depth or 1
    if max_depth and depth > max_depth then
      return
    end

    for name, t in vim.fs.dir(path) do
      local full = path .. "/" .. name
      if t == "file" then
        if match_patterns(name) then
          local stat = vim.uv.fs_stat(full)
          if stat then
            ret[#ret + 1] = { path = full, stat = stat }
          end
        end
      elseif t == "directory" and name ~= ".git" then
        scan(full, depth + 1)
      end
    end
  end

  scan(cwd)

  table.sort(ret, function(a, b)
    return a.stat.mtime.sec > b.stat.mtime.sec
  end)

  return ret
end

-- Snacks-style picker for recent files
local function recent_files(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()
  local root = vim.fn.fnamemodify(opts.cwd, ":p")
  local raw_items = list_by_mtime(opts)
  --- Convert raw items into Snacks picker-compatible items
  local items = {}
  for _, item in ipairs(raw_items) do
    local text = vim.fn.fnamemodify(item.path, ":h") -- immediate parent dir
    text = item.path:sub(#root + 2)
    table.insert(items, {
      text = text,
      file = item.path, -- this is what will be displayed
      data = item, -- keep the full table for actions
    })
  end
  return items
end

local add_new_file = function(root, picker, item)
  local path = root .. "/" .. picker.finder.filter.pattern
  local parent = vim.fn.fnamemodify(path, ":h")
  -- if parent directory doesn't exist, warn and give option
  if vim.fn.isdirectory(parent) == 0 then
    Snacks.notify.warn("Directory does not exist")
    if vim.fn.confirm("Create Directory ?", "&Yes\n&No", 2) ~= 1 then
      return
    else
      vim.fn.mkdir(parent)
    end
  end
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({}, path)
    Snacks.notify.info("New File Created")
  end
  picker:refresh()
end

local function recent_files_picker(opts)
  local root = vim.fn.fnamemodify(opts.cwd, ":p")
  Snacks.picker({
    title = opts.title or "Recent Files",
    finder = function()
      return recent_files(opts)
    end,
    format = "text",
    confirm = function(picker, item)
      if item then
        picker:close()
        vim.cmd(("edit %s"):format(vim.fn.fnameescape(item.file)))
      else
        add_new_file(root, picker, item)
      end
    end,
    preview = "file",
    actions = {
      new_file = function(picker, item)
        add_new_file(root, picker, item)
      end,
      delete_file = function(picker, item)
        local name = vim.fn.fnamemodify(item.file, ":t")
        if vim.fn.confirm(("Delete %s ?"):format(name), "&Yes\n&No", 2) ~= 1 then
          return
        end
        os.remove(item.file)
        Snacks.notify.info("Deleted " .. name)
        picker:refresh()
      end,
    },
    win = {
      input = {
        keys = {
          ["d"] = "delete_file", -- press 'd' to delete
          ["<c-n>"] = { "new_file", mode = { "i", "n" } },
        },
      },
    },
  })
end

local function pick_cmd_result(picker_opts)
  local git_root = Snacks.git.get_root()
  local function finder(opts, ctx)
    return require("snacks.picker.source.proc").proc({
      opts,
      {
        cmd = picker_opts.cmd,
        args = picker_opts.args,
        transform = function(item)
          item.cwd = picker_opts.cwd or git_root
          item.file = item.text
        end,
      },
    }, ctx)
  end

  Snacks.picker.pick({
    source = picker_opts.name,
    finder = finder,
    preview = picker_opts.preview,
    title = picker_opts.title,
  })
end

local custom_pickers = {}

function custom_pickers.git_show()
  pick_cmd_result({
    cmd = "git",
    args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD", "-r", "2bed2aa" },
    name = "git_show",
    title = "Git Last Commit",
    preview = "git_show",
  })
end

function custom_pickers.git_diff_upstream()
  pick_cmd_result({
    cmd = "git",
    args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD@{u}..HEAD", "-r" },
    name = "git_diff_upstream",
    title = "Git Branch Changed Files",
    preview = "file",
  })
end

return {

  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  {
    "folke/snacks.nvim",
    keys = function(_, keys)
      if LazyVim.pick.picker.name ~= "snacks" then
        return
      end
      local obsidian_icloud_docs = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents"
      local mappings = {
        {
          "<leader>s>",
          function()
            local word = vim.fn.expand("<cword>")
            Snacks.picker.lines().input:set(word)
          end,
          desc = "Buffer Words",
        },
        {
          "<leader><tab>p",
          mode = { "n", "x" },
          desc = "Tabs",
          function()
            tabs_picker()
          end,
        },
        {
          "<leader>so",
          mode = { "n", "x" },
          desc = "Obsidian Files",
          function()
            Snacks.picker.grep({
              title = "Grep Obsidian Files",
              dirs = { obsidian_icloud_docs },
              globs = "*.md",
            })
          end,
        },
        {
          "<leader>fo",
          mode = { "n", "x" },
          desc = "Obsidian Files",
          function()
            recent_files_picker({
              title = "Obsidian Files",
              patterns = { "*.md", "*.jp*" },
              cwd = obsidian_icloud_docs,
            })
          end,
        },
        {
          "<leader>sP",
          mode = { "n", "x" },
          desc = "Plugin Directories",
          function()
            directory_picker({
              cwd = vim.fn.stdpath("data") .. "/lazy/",
              source = "Lazy Plugins",
            })
          end,
        },
        {
          "<leader>fx",
          mode = { "n", "x" },
          desc = "Find in Git Show",
          function()
            custom_pickers.git_show()
          end,
        },
        {
          "<leader>fy",
          mode = { "n", "x" },
          desc = "Find in Git Diff",
          function()
            custom_pickers.git_diff_upstream()
          end,
        },
        {
          "<leader>z=",
          mode = { "n", "x" },
          desc = "Spelling Suggestions",
          function()
            Snacks.picker.spelling()
          end,
        },
        {
          "<leader>sz",
          mode = { "n", "x" },
          desc = "Zoxide",
          function()
            Snacks.picker.zoxide({
              confirm = function(picker)
                picker:close()
                local item = picker:current()
                if item and item.file then
                  vim.cmd.tcd(item.file)
                end
              end,
            })
          end,
        },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = function(_, opts)
      if LazyVim.pick.picker.name ~= "snacks" then
        return
      end
      -- Add markdown root markers into projects
      local patterns = { ".marksman.toml" }
      vim.list_extend(patterns, require("snacks.picker.config.sources").projects.patterns)
      -- Add obsidian docs to dev in projects
      local dev = { "~/Library/Mobile Documents/iCloud~md~obsidian/Documents" }
      local current_dev = require("snacks.picker.config.sources").projects.dev
      vim.list_extend(dev, type(current_dev) == "string" and { current_dev } or current_dev --[[@as string[] ]])
      -- Add into the projects options along with jj mapping for esc in all pickers
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          sources = {
            projects = {
              patterns = patterns,
              max_depth = 3,
              dev = dev,
            },
          },
          win = {
            input = {
              keys = {
                ["jj"] = { "<esc>", expr = true, mode = "i" },
              },
            },
          },
        },
      })
    end,
  },
}
