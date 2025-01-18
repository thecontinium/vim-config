local map = vim.keymap.set

-- Use Marked for real-time Markdown preview
-- See: https://marked2app.com/
if vim.fn.executable('/Applications/Marked 2.app') then
	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('rafi_marked_preview', {}),
		pattern = 'markdown',
		callback = function()
			local cmd = "<cmd>silent !open -a Marked\\ 2.app '%:p'<CR>"
			vim.keymap.set('n', '<Leader>P', cmd, { desc = 'Markdown Preview' })
		end,
	})
end

map({ 'n', 'x' }, '<localleader>s', '<cmd>Telescope neovim-project history<CR>', { remap = true, desc = 'Sessions' })

-- Ultimatus Quitos
if vim.F.if_nil(vim.g.window_q_mapping, true) then
	map('n', 'q', function()
		local plugins = {
			'blame',
			'checkhealth',
			'fugitive',
			'fugitiveblame',
			'help',
			'httpResult',
			'lspinfo',
			'notify',
			'PlenaryTestPopup',
			'qf',
			'spectre_panel',
			'startuptime',
			'tsplayground',
		}
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(plugins, vim.bo[buf].filetype) then
			vim.bo[buf].buflisted = false
		end
		-- Find non-floating windows
		local wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, win)
				if vim.api.nvim_win_get_config(win).zindex then
					return nil
				end
				return win
			end)
		-- If last window, quit
		if #wins > 1 then
			vim.api.nvim_win_close(0, false)
		else
			vim.cmd[[quit]]
		end
	end, { desc = 'Close window' })
end

