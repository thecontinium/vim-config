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

local map = vim.keymap.set
local unmap = function(modes, lhs)
	modes = type(modes) == 'string' and { modes } or modes
	lhs = type(lhs) == 'string' and { lhs } or lhs
	for _, mode in pairs(modes) do
		for _, l in pairs(lhs) do
			pcall(vim.keymap.del, mode, l)
		end
	end
end

unmap('n', {'<localleader>s',})
map({ 'n', 'x' }, '<localleader>s', '<cmd>Telescope neovim-project history<CR>', { remap = true, desc = 'Sessions' })
