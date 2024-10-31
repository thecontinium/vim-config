return {
	-- {
	--   "bluz71/vim-moonfly-colors",
	--   lazy = false,
	--   priority = 1000,
	--   config = function()
	--     vim.cmd.syntax("enable")
	--     vim.cmd.colorscheme("moonfly")
	--
	--     vim.api.nvim_set_hl(0, "MoltenOutputBorder", { link = "Normal" })
	--     vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { link = "MoonflyCrimson" })
	--     vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { link = "MoonflyBlue" })
	--   end,
	-- },
	{
		'benlubas/molten-nvim',
		ft = { 'python', 'ipynb' },
		dependencies = { '3rd/image.nvim' },
		build = ':UpdateRemotePlugins',
		init = function()
			vim.g.molten_image_provider = 'image.nvim'
			vim.g.molten_use_border_highlights = true -- I find auto open annoying, keep in mind setting this option will require setting
			-- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
			vim.g.molten_auto_open_output = false
			-- optional, I like wrapping. works for virt text and the output window
			vim.g.molten_wrap_output = false
			-- Output as virtual text. Allows outputs to always be shown, works with images, but can
			-- be buggy with longer images
			vim.g.molten_virt_text_output = true
			-- this will make it so the output shows up below the \`\`\` cell delimiter
			vim.g.molten_virt_lines_off_by_1 = true
			-- add a few new things

			-- Autocmd to set cell markers
			vim.api.nvim_create_autocmd({ 'BufEnter' }, { -- "BufWriteCmd"
				pattern = { '*.py', '*.ipynb' },
				callback = function()
					vim.api.nvim_set_hl(0, 'MoltenCell', { link = 'FloatShadow' })
					vim.api.nvim_set_hl(
						0,
						'@python_code_block_start',
						{ fg = '#FF5733', bg = '#2D2D2D', bold = true }
					)
					-- vim.keymap.set(
					-- 	"n",
					-- 	",eb",
					-- 	":MoltenEvaluateOperator<CR>:call feedkeys(\"io\")<CR>",
					-- 	{ desc = "evaluate block", buffer = true, silent = true }
					-- )
					vim.keymap.set(
						'n',
						',eo',
						':MoltenEvaluateOperator<CR>',
						{ desc = 'evaluate operator', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',ec',
						':MoltenReevaluateCell<cr>',
						{ desc = 're-eval cell', buffer = true, silent = true }
					)
					vim.keymap.set(
						'v',
						',ev',
						':<c-u>MoltenEvaluateVisual<cr>gv',
						{ desc = 'execute visual selection', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',oh',
						':MoltenHideOutput<cr>',
						{ desc = 'close output window', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',oe',
						'<cmd>noautocmd MoltenEnterOutput<CR>',
						{ desc = 'enter output', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',md',
						':MoltenDelete<cr>',
						{ desc = 'delete molten cell', buffer = true, silent = true }
					)
				end,
			})
		end,
	},
	{
		'3rd/image.nvim',
		opts = {
			backend = 'kitty',
			integrations = {},
			max_width = 300,
			max_height = 36,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
		},
		version = '1.1.0', -- or comment out for latest
		dependencies = {
			'kiyoon/magick.nvim',
		},
	},
	{
		'GCBallesteros/jupytext.nvim',
		config = true,
		opts = {
			style = 'markdown',
			output_extension = 'md',
			force_ft = 'markdown',
		},
		-- Depending on your nvim distro or config you may need to make the loading not lazy
		lazy = false,
    priority = 1000, -- make sue it is loaded before neovim-project so BufRead is triggered
	},
	{
		'quarto-dev/quarto-nvim',
		dependencies = {
			'jmbuhr/otter.nvim',
			'nvim-treesitter/nvim-treesitter',
		},
		ft = { 'quarto', 'markdown' },
		init = function()
			vim.api.nvim_create_autocmd('filetype', {
				pattern = 'markdown',
				callback = function()
					require('quarto').activate()
					local runner = require('quarto.runner')
					vim.keymap.set(
						'n',
						',rc',
						runner.run_cell,
						{ desc = 'run cell', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',ra',
						runner.run_above,
						{ desc = 'run cell and above', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',rA',
						runner.run_all,
						{ desc = 'run all cells', buffer = true, silent = true }
					)
					vim.keymap.set(
						'n',
						',rl',
						runner.run_line,
						{ desc = 'run line', buffer = true, silent = true }
					)
					vim.keymap.set(
						'v',
						',rv',
						runner.run_range,
						{ desc = 'run visual range', buffer = true, silent = true }
					)
				end,
			})
		end,
		opts = {
			lspFeatures = {
				languages = { 'python' },
				chunks = 'all',
				diagnostics = {
					enabled = true,
					triggers = { 'BufWritePost' },
				},
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = true,
				default_method = 'molten',
			},
		},
	},

	{
		'nvim-treesitter/nvim-treesitter',
		-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		opts = {
			textobjects = {
				move = {
					goto_next_start = {
						[']b'] = '@block.inner',
					},
					goto_previous_start = {
						['[b'] = '@block.inner',
					},
				},
			},
		},
	},
}
