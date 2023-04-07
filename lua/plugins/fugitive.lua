return {
	{
		'tpope/vim-fugitive',
		dependencies = { 'tpope/vim-rhubarb' },
		cmd = { 'G', 'Git', 'GBrowse', 'Gfetch', 'Gclog', 'Gdiffsplit' },
		keys = {
			{ '<leader>gd', '<cmd>Gdiffsplit<CR>' },
			{ '<leader>gb', '<cmd>Git blame<CR>' },
			{ '<leader>go', '<cmd>GBrowse<CR>' },
			{ '<leader>go', ':GBrowse<CR>', mode = 'x' },
			{ '<leader>gp', '<cmd>G push<CR>'},
		},
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_fugitive', {}),
				pattern = 'fugitiveblame',
				callback = function()
					vim.schedule(function()
						vim.cmd.normal('A')
					end)
				end
			})
		end
	},
}
