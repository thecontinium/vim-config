-- rafi preview functions
-- https://github.com/rafi/vim-config
-- requires telescope

local M = {}

local opts = {}

local default_opts = {
	popup = {
		enter = false,
		-- moved = 'any',  -- doesn't work.
		focusable = true,
		noautocmd = true,
		relative = 'cursor',
		line = 5, -- 'cursor-4',
		col = 32, -- 'cursor+20',
		minwidth = math.ceil(vim.o.columns / 2),
		minheight = math.ceil(vim.o.lines / 1.5),
		border = true,
		borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
		highlight = 'Normal',
		borderhighlight = 'FloatBorder',
		titlehighlight = 'Title',
		zindex = 100,
	},
}

opts = vim.deepcopy(default_opts)

---@param popup_state table
---@param augroup integer
local function close(popup_state, augroup)
	vim.schedule(function()
		local utils = require('telescope.utils')
		pcall(vim.api.nvim_del_augroup_by_id, augroup)
		utils.win_delete('preview_border_win', popup_state.win_id, true, true)
		if popup_state.border and popup_state.border.win_id then
			utils.win_delete(
				'preview_border_win',
				popup_state.border.win_id,
				true,
				true
			)
		end
	end)
end

---@param user_opts table
function M.setup(user_opts)
	user_opts = vim.F.if_nil(user_opts, {})
	opts = vim.tbl_deep_extend('keep', user_opts, default_opts)
end

---@param path string
function M.open(path)
	local bufnr = vim.api.nvim_get_current_buf()
	local popup = require('plenary.popup')
	opts.popup.title = path
	local winid, popup_state = popup.create('', opts.popup)
	local popup_bufnr = vim.api.nvim_win_get_buf(winid)

	-- Ensure best viewing options are toggled.
	vim.api.nvim_win_set_option(winid, 'number', true)
	vim.api.nvim_win_set_option(winid, 'relativenumber', false)
	vim.api.nvim_win_set_option(winid, 'wrap', false)
	vim.api.nvim_win_set_option(winid, 'spell', false)
	vim.api.nvim_win_set_option(winid, 'list', false)
	vim.api.nvim_win_set_option(winid, 'foldenable', false)
	vim.api.nvim_win_set_option(winid, 'cursorline', false)
	vim.api.nvim_win_set_option(winid, 'signcolumn', 'no')
	vim.api.nvim_win_set_option(winid, 'colorcolumn', '')
	vim.api.nvim_win_set_option(winid, 'winhighlight', 'Normal:NormalFloat')

	-- Run telescope preview.
	require('telescope.config').values.buffer_previewer_maker(
		path,
		popup_bufnr,
		{}
	)

	-- Setup close events
	local augroup = vim.api.nvim_create_augroup('preview_window_' .. winid, {})

	-- Close the preview window when entered a buffer that is not
	-- the floating window buffer or the buffer that spawned it.
	vim.api.nvim_create_autocmd('BufEnter', {
		group = augroup,
		callback = function()
			-- close preview unless we're in original window or popup window
			local bufnrs = { popup_bufnr, bufnr }
			if not vim.tbl_contains(bufnrs, vim.api.nvim_get_current_buf()) then
				close(popup_state, augroup)
			end
		end,
	})

	-- Create autocommands to close a preview window when events happen.
	local events = { 'CursorMoved', 'BufUnload', 'InsertCharPre', 'ModeChanged' }
	vim.api.nvim_create_autocmd(events, {
		group = augroup,
		buffer = bufnr,
		once = true,
		callback = function()
			close(popup_state, augroup)
		end,
	})
end

return M
