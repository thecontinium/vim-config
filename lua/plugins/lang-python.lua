local conda_prefix = os.getenv('CONDA_PREFIX')
local python_path = nil
if conda_prefix ~= nil then
	python_path = conda_prefix .. '/bin/python'
else
	python_path = vim.g.python3_host_prog
end

vim.g.lazyvim_python_lsp = 'basedpyright'
vim.g.lazyvim_python_ruff = 'ruff'

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

	-- Configuration for Pylsp: Use Ruff installed with :PylspInstall python-lsp-ruff
	-- https://jdhao.github.io/2023/07/22/neovim-pylsp-setup/
	-----------------------------------------------------------------------------
	{
		'benlubas/molten-nvim',
		ft = { 'python', 'ipynb' },
		dependencies = { 'quarto-dev/quarto-nvim', '3rd/image.nvim' },
		build = ':UpdateRemotePlugins',
		init = function()
			vim.g.molten_image_provider = 'image.nvim'
			vim.g.molten_use_border_highlights = true
			-- I find auto open annoying, keep in mind setting this option will require setting
			-- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
			vim.g.molten_auto_open_output = false
			vim.g.molten_enter_output_behavior = 'open_and_enter'
			-- optional, I like wrapping. works for virt text and the output window
			vim.g.molten_wrap_output = false
			-- Output as virtual text. Allows outputs to always be shown, works with images, but can
			-- be buggy with longer images
			vim.g.molten_virt_text_output = true
			-- this will make it so the output shows up below the \`\`\` cell delimiter
			-- vim.g.molten_virt_lines_off_by_1 = true
			-- add a few new things

			-- Autocmd to set cell markers
			vim.api.nvim_create_autocmd({ 'BufEnter' }, { -- "BufWriteCmd"
				pattern = { '*.py', '*.ipynb' },
				callback = function(args)
					vim.api.nvim_set_hl(0, 'MoltenCell', { link = 'FloatShadow' })
					local runner = require('quarto.runner')
					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	'@python_code_block_start',
					-- 	{ fg = '#FF5733', bg = '#2D2D2D', bold = true }
					-- )
					-- vim.keymap.set(
					-- 	"n",
					-- 	",eb",
					-- 	":MoltenEvaluateOperator<CR>:call feedkeys(\"io\")<CR>",
					-- 	{ desc = "evaluate block", buffer = true, silent = true }
					-- )
					local wk = require('which-key')
					wk.add({
						{ ',', mode = 'n', buffer = args.buf, group = '+' .. args.match },
						{ ',e', mode = 'n', buffer = args.buf, group = '+evaluate' },
						{
							',eo',
							':MoltenEvaluateOperator<CR>',
							mode = 'n',
							buffer = args.buf,
							desc = 'evaluate operator',
						},
						{
							',el',
							':MoltenEvaluateLine<CR>',
							mode = 'n',
							buffer = args.buf,
							desc = 'evaluate line',
						},
						{
							',ec',
							':MoltenReevaluateCell<cr>',
							mode = 'n',
							buffer = args.buf,
							desc = 're-evaluate cell',
						},
						{
							',ed',
							':MoltenDelete<cr>',
							mode = 'n',
							buffer = args.buf,
							desc = 'delete cell',
						},
						{
							',ev',
							':<c-u>MoltenEvaluateVisual<cr>gv',
							mode = 'v',
							buffer = args.buf,
							desc = 'evaluate visual selection',
						},
						{ ',o', mode = 'n', buffer = args.buf, group = '+output' },
						{
							',oh',
							':MoltenHideOutput<cr>',
							mode = 'n',
							buffer = args.buf,
							desc = 'close output window',
						},
						{
							',oe',
							'<cmd>noautocmd MoltenEnterOutput<CR>',
							mode = 'n',
							buffer = args.buf,
							desc = 'enter output',
						},
						{ ',r', mode = 'n', buffer = args.buf, group = '+quarto run' },
						{
							',rc',
							runner.run_cell,
							mode = 'n',
							buffer = args.buf,
							desc = 'run cell',
						},
						{
							',ra',
							runner.run_above,
							mode = 'n',
							buffer = args.buf,
							desc = 'run cell and above',
						},
						{
							',rA',
							runner.run_all,
							mode = 'n',
							buffer = args.buf,
							desc = 'run all cells',
						},
						{
							',rl',
							runner.run_line,
							mode = 'n',
							buffer = args.buf,
							desc = 'run line',
						},
						{
							',rv',
							runner.run_range,
							mode = 'v',
							buffer = args.buf,
							desc = 'run visual range',
						},
					})
					require('quarto').activate()
				end,
			})
		end,
	},
	-----------------------------------------------------------------------------
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
	-----------------------------------------------------------------------------
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
	-----------------------------------------------------------------------------
	{
		'quarto-dev/quarto-nvim',
		dependencies = {
			'jmbuhr/otter.nvim',
			'nvim-treesitter/nvim-treesitter',
			'neovim/nvim-lspconfig',
		},
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
	-----------------------------------------------------------------------------
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
	-----------------------------------------------------------------------------
	{ import = 'lazyvim.plugins.extras.dap.core' },
	{
		'linux-cultist/venv-selector.nvim',
		opts = {
			settings = {
				options = {
					enable_default_searches = false,
					on_telescope_result_callback = function(filename)
						return filename:gsub(os.getenv('HOME'), '~'):gsub('/bin/python', '')
					end,
				},
				search = {
					minis = {
						command = "fd 'bin/python$' /usr/local/Caskroom/miniconda/base/envs --full-path --color never",
						type = 'anaconda',
					},
					pyenvs = {
						command = "fd '/bin/python$' $PYENV_ROOT/versions --full-path --color never -E pkgs/ -E envs/ -L",
					},
				},
			},
		},
	},
	-- {
	-- 	'mfussenegger/nvim-dap',
	-- 	ft = { 'python' },
	-- 	dependencies = {
	-- 		'nvim-neotest/nvim-nio',
	-- 		'rcarriga/nvim-dap-ui',
	-- 		'mfussenegger/nvim-dap-python',
	-- 		'theHamsta/nvim-dap-virtual-text',
	-- 	},
	-- 	config = function()
	-- 		local dap = require('dap')
	-- 		local dapui = require('dapui')
	-- 		local dap_python = require('dap-python')
	--
	-- 		require('dapui').setup({})
	-- 		require('nvim-dap-virtual-text').setup({
	-- 			commented = true, -- Show virtual text alongside comment
	-- 		})
	--
	-- 		dap_python.setup('python3')
	--
	-- 		vim.fn.sign_define('DapBreakpoint', {
	-- 			text = '',
	-- 			texthl = 'DiagnosticSignError',
	-- 			linehl = '',
	-- 			numhl = '',
	-- 		})
	--
	-- 		vim.fn.sign_define('DapBreakpointRejected', {
	-- 			text = '', -- or "❌"
	-- 			texthl = 'DiagnosticSignError',
	-- 			linehl = '',
	-- 			numhl = '',
	-- 		})
	--
	-- 		vim.fn.sign_define('DapStopped', {
	-- 			text = '', -- or "→"
	-- 			texthl = 'DiagnosticSignWarn',
	-- 			linehl = 'Visual',
	-- 			numhl = 'DiagnosticSignWarn',
	-- 		})
	--
	-- 		-- Automatically open/close DAP UI
	-- 		dap.listeners.after.event_initialized['dapui_config'] = function()
	-- 			dapui.open()
	-- 		end
	--
	-- 		local function opts(description)
	-- 			return {
	-- 				noremap = true,
	-- 				silent = true,
	-- 				buffer = true,
	-- 				desc = description,
	-- 			}
	-- 		end
	--
	-- 		vim.api.nvim_create_autocmd('filetype', {
	-- 			group = vim.api.nvim_create_augroup('group_python-wk', {}),
	-- 			pattern = 'python',
	-- 			callback = function(args)
	-- 				local wk = require('which-key')
	-- 				wk.add({
	-- 					{
	-- 						',d',
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						group = '+dab-' .. args.match,
	-- 					},
	-- 					{
	-- 						',db',
	-- 						function()
	-- 							dap.toggle_breakpoint()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'toggle breakpoint',
	-- 					},
	-- 					{
	-- 						',dc',
	-- 						function()
	-- 							dap.continue()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'continue',
	-- 					},
	-- 					{
	-- 						',de',
	-- 						function()
	-- 							dapui.eval(nil, { enter = true })
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'eval',
	-- 					},
	-- 					{
	-- 						',do',
	-- 						function()
	-- 							dap.step_over()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'step over',
	-- 					},
	-- 					{
	-- 						',di',
	-- 						function()
	-- 							dap.step_into()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'step into',
	-- 					},
	-- 					{
	-- 						',dO',
	-- 						function()
	-- 							dap.step_out()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'step out',
	-- 					},
	-- 					{
	-- 						',dq',
	-- 						function()
	-- 							dap.terminate()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'terminate',
	-- 					},
	-- 					{
	-- 						',du',
	-- 						function()
	-- 							dapui.toggle()
	-- 						end,
	-- 						mode = 'n',
	-- 						buffer = args.buf,
	-- 						desc = 'toggle',
	-- 					},
	-- 				})
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	{ import = 'lazyvim.plugins.extras.lang.python' },
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				basedpyright = {
					settings = {
						basedpyright = {
							-- Using Ruff's import organizer
							disableOrganizeImports = true,
							-- Set the type cheching mode
							typeCheckingMode = 'basic',
						},
						python = {
							analysis = {
								-- Ignore all files for analysis to exclusively use Ruff for linting
								ignore = { '*' },
							},
						},
					},
				},
			},
		},
	},
	-- not using extras this worked for using ruff and basedpyright
	-- {
	-- 	'neovim/nvim-lspconfig',
	-- 	opts = {
	-- 		setup = {
	-- 			ruff = function()
	-- 				LazyVim.lsp.on_attach(function(client, _)
	-- 					-- Disable hover in favor of Pyright
	-- 					client.server_capabilities.hoverProvider = false
	-- 				end, 'ruff')
	-- 			end,
	-- 		},
	-- 		servers = {
	-- 			ruff = {
	-- 				cmd_env = { RUFF_TRACE = 'messages' },
	-- 				init_options = {
	-- 					settings = {
	-- 						logLevel = 'error',
	-- 					},
	-- 				},
	-- 				keys = {
	-- 					{
	-- 						'<leader>co',
	-- 						LazyVim.lsp.action['source.organizeImports'],
	-- 						desc = 'Organize Imports',
	-- 					},
	-- 				},
	-- 			},
	-- 			basedpyright = {
	-- 				settings = {
	-- 					basedpyright = {
	-- 						-- Using Ruff's import organizer
	-- 						disableOrganizeImports = true,
	-- 						-- Set the type cheching mode
	-- 						typeCheckingMode = 'basic',
	-- 					},
	-- 					python = {
	-- 						analysis = {
	-- 							-- Ignore all files for analysis to exclusively use Ruff for linting
	-- 							ignore = { '*' },
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
	--
	-- not using extras this worked for using pylsp
	-- {
	-- 	'neovim/nvim-lspconfig',
	-- 	opts = {
	-- 		setup = {
	-- 			pylsp = {
	-- 				settings = {
	-- 					pylsp = {
	-- 						plugins = {
	-- 							-- formatter options
	-- 							-- ussing ruff
	-- 							black = { enabled = false }, -- pyproject.toml
	-- 							autopep8 = { enabled = false },
	-- 							yapf = { enabled = false },
	-- 							-- linter options
	-- 							ruff = { enabled = true, formatEnabled = true }, --disabled by default pycodestyle, pyflakes, mccabe, autopep8, and yapf -- pyproject.toml; :PylspInstall
	-- 							pylint = { enabled = false, executable = 'pylint' }, -- pyproject.toml
	-- 							pyflakes = { enabled = false },
	-- 							pycodestyle = { enabled = false },
	-- 							flake8 = { enabled = false },
	-- 							pydocstyle = { enabled = false },
	-- 							-- type checker
	-- 							pylsp_mypy = { enabled = false },
	-- 							-- pylsp_mypy = { -- pyproject.toml :PylspInstall lsp-mypy
	-- 							-- 	enabled = true,
	-- 							-- 	overrides = { '--python-executable', python_path, true },
	-- 							-- 	report_progress = true,
	-- 							-- 	live_mode = false,
	-- 							-- },
	-- 							-- auto-completion options
	-- 							jedi_completion = { fuzzy = true },
	-- 							-- import sorting
	-- 							isort = { enabled = true }, -- not sure if this is being used -- pyproject.toml; :PylspInstall python-isort
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
}
