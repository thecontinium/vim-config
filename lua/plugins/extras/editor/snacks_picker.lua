-- Custom pickers
-- Directory Picker
local function directory_picker(opts)
	opts = opts or {}
	local current_dir = opts.cwd or vim.fn.getcwd()
	local source = opts.source or 'directories'
	local dirs = {}

	-- Get immediate subdirectories
	local handle = vim.loop.fs_scandir(current_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end
			if type == 'directory' then
				table.insert(dirs, name)
			end
		end
	end

	table.sort(dirs)

	-- Convert to table format
	local items = {}
	for _, dir in ipairs(dirs) do
		local full_path = current_dir .. '/' .. dir
		table.insert(items, { text = dir, value = full_path })
	end

	Snacks.picker.pick({
		source = source,
		items = items,
		layout = { preset = 'select' },
		format = 'text',
		confirm = function(picker, item)
			picker:close()
			Snacks.notify.info('Changed directory to Lazy Plugin ' .. item.text)
			vim.cmd('cd ' .. item.value)
		end,
	})
end

-- Key mapping
vim.keymap.set('n', '<localleader>P', function()
	directory_picker({
		cwd = vim.fn.stdpath('data') .. '/lazy/',
		source = 'Lazy Plugins',
	})
end, { desc = 'Plugin Directories' })

-- Tabs Picker
local function get_tabs()
	local tabs = {}
	local tabpages = vim.api.nvim_list_tabpages()
	for i, tabpage in ipairs(tabpages) do
		local wins = vim.api.nvim_tabpage_list_wins(tabpage)
		local cur_win = vim.api.nvim_tabpage_get_win(tabpage)
		local buf = vim.api.nvim_win_get_buf(cur_win)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
		if name == '' then
			name = '[No Name]'
		end

		local preview_lines = {}
		table.insert(
			preview_lines,
			('Tab %d: %d window%s'):format(i, #wins, #wins == 1 and '' or 's')
		)
		table.insert(
			preview_lines,
			('%-6s %-8s %s'):format('WinID', 'Buf#', 'File')
		)
		table.insert(preview_lines, string.rep('-', 40))
		for _, win in ipairs(wins) do
			local win_buf = vim.api.nvim_win_get_buf(win)
			local bufname = vim.api.nvim_buf_get_name(win_buf)
			if bufname == '' then
				bufname = '[No Name]'
			end
			bufname = vim.fn.fnamemodify(bufname, ':~:.') -- relative to cwd, or ~
			local win_marker = (win == cur_win) and '->' or '  '
			table.insert(
				preview_lines,
				('%s %-6d %-8d %s'):format(win_marker, win, win_buf, bufname)
			)
		end
		if #wins == 0 then
			table.insert(preview_lines, 'No windows in tab')
		end

		table.insert(tabs, {
			idx = i,
			text = ('Tab %d: %s'):format(i, name),
			tabnr = i,
			tabpage = tabpage,
			preview = {
				text = table.concat(preview_lines, '\n'),
				ft = 'text',
			},
		})
	end
	return tabs
end

local function tabs_picker()
	local items = get_tabs()
	Snacks.picker({
		title = 'Tabs',
		items = items,
		format = 'text',
		confirm = function(picker, item)
			picker:close()
			vim.cmd(('tabnext %d'):format(item.tabnr))
		end,
		preview = 'preview',
		actions = {
			close_tab = function(picker, item)
				picker:close()
				vim.cmd(('tabclose %d'):format(item.tabnr))
			end,
		},
		win = {
			input = {
				keys = {
					['d'] = 'close_tab',
				},
			},
		},
	})
end

-- Key mapping
vim.keymap.set('n', '<leader><tab>p', function() tabs_picker() end, { desc = 'Tabs' })

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

  Snacks.picker.pick {
    source = picker_opts.name,
    finder = finder,
    preview = picker_opts.preview,
    title = picker_opts.title,
  }
end

local custom_pickers = {}

function custom_pickers.git_show()
  pick_cmd_result {
    cmd = "git",
    args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD", "-r", "2bed2aa" },
    name = "git_show",
    title = "Git Last Commit",
    preview = "git_show",
  }
end

function custom_pickers.git_diff_upstream()
  pick_cmd_result {
    cmd = "git",
    args = { "diff-tree", "--no-commit-id", "--name-only", "--diff-filter=d", "HEAD@{u}..HEAD", "-r" },
    name = "git_diff_upstream",
    title = "Git Branch Changed Files",
    preview = "file",
  }
end

vim.keymap.set('n', '<leader>fx', function()  custom_pickers.git_show() end, { desc = "Find in Git Show" })
vim.keymap.set('n', '<leader>fy', function()  custom_pickers.git_diff_upstream() end, { desc = "Find in Git Show" })

return {
	{ import = 'lazyvim.plugins.extras.editor.snacks_picker' },
}
