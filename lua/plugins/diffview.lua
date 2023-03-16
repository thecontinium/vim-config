return {

	-----------------------------------------------------------------------------
	{
		'sindrets/diffview.nvim',
		cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
		keys = {
			{ '<Leader>gv', '<cmd>DiffviewOpen<CR>', desc = 'Diff View' }
		},
		config = function()
			local actions = require('diffview.actions')
			vim.cmd [[
				augroup rafi_diffview
					autocmd!
					autocmd WinEnter,BufEnter diffview://* setlocal cursorline
					autocmd WinEnter,BufEnter diffview:///panels/* setlocal winhighlight=CursorLine:WildMenu
				augroup END
			]]

			require('diffview').setup({
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				keymaps = {
					view = {
						{'n', 'q',       '<cmd>DiffviewClose<CR>' },
						{'n', '<tab>',   actions.select_next_entry },
						{'n', '<s-tab>', actions.select_prev_entry },
						{'n', ';a',      actions.focus_files },
						{'n', ';e',      actions.toggle_files },
					},
					file_panel = {
						{'n', 'q',       '<cmd>DiffviewClose<CR>' },
						{'n', 'j',       actions.next_entry },
						{'n', '<down>',  actions.next_entry },
						{'n', 'k',       actions.prev_entry },
						{'n', '<up>',    actions.prev_entry },
						{'n', 'h',       actions.prev_entry },
						{'n', 'l',       actions.select_entry },
						{'n', '<cr>',    actions.select_entry },
						{'n', 'o',       actions.focus_entry },
						{'n', 'gf',      actions.goto_file },
						{'n', 'sg',      actions.goto_file_split },
						{'n', 'st',      actions.goto_file_tab },
						{'n', 'r',       actions.refresh_files },
						{'n', 'R',       actions.refresh_files },
						{'n', '<c-r>',   actions.refresh_files },
						{'n', '<tab>',   actions.select_next_entry },
						{'n', '<s-tab>', actions.select_prev_entry },
						{'n', ';a',      actions.focus_files },
						{'n', ';e',      actions.toggle_files },
					},
					file_history_panel = {
						{'n', 'o',    actions.focus_entry },
						{'n', 'l',    actions.select_entry },
						{'n', '<cr>', actions.select_entry },
						{'n', 'O',    actions.options },
					},
					option_panel = {
						{'n', '<tab>', actions.select_entry },
						{'n', 'q',     actions.close },
					},
				}
			})
		end
	},
}
