-- vim.cmd.runtime("plugin/zipPlugin.vim")
local util = require('lspconfig.util')

return {
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				clojure_lsp = {
					root_dir = util.root_pattern(
						'workspace.edn',
						'project.clj',
						'deps.edn',
						'build.boot',
						'shadow-cljs.edn',
						'bb.edn'
					),
				},
			},
		},
	},

	{
		'nvim-treesitter/nvim-treesitter',
		opts = {
			-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			textobjects = {
				select = {
					disable = { 'clojure' },
				},
				move = {
					disable = { 'clojure' },
				},
				swap = {
					disable = { 'clojure' },
				},
			},
		},
	},

	{
		'paterjason/nvim-treesitter-sexp',
		ft = 'clojure',
		dependencies = { 'echasnovski/mini.surround', 'folke/which-key.nvim' },
		init = function()
			vim.api.nvim_create_autocmd('filetype', {
				group = vim.api.nvim_create_augroup('group_treesitter-sexp', {}),
				pattern = 'clojure',
				callback = function()
					vim.keymap.set(
						'n',
						',w',
						'saie)<i',
						{ buffer = true, remap = true, desc = 'insert surround elem head' }
					)
					vim.keymap.set(
						'n',
						',W',
						'saie)>i ',
						{ buffer = true, remap = true, desc = 'insert surround elem tail' }
					)
					vim.keymap.set(
						'n',
						',i',
						'saif)((<i',
						{ buffer = true, remap = true, desc = 'insert surround form head' }
					)
					vim.keymap.set(
						'n',
						',I',
						'saif)))>i ',
						{ buffer = true, remap = true, desc = 'insert surround form tail' }
					)
				end,
			})

			local function add_sub_key(table, l, v)
				local k1 = l:sub(1, 1)
				local k2 = l:sub(2, 2)
				if l:len() > 1 then
					k1 = l:sub(1, l:len() - 1)
					k2 = l:sub(l:len(), l:len())
				end
				if k1 == '' then
					k1 = l
				end
				if k2 ~= '' then
					if table[k1] == nil then
						table[k1] = {}
					end
					table[k1][k2] = v
				else
					table[k1] = v
				end
			end

			local function add_which_key(km, ks, opts)
				local wk = require('which-key')
				local w = {}
				for key, lhs in pairs(km) do
					local k = ks[key]
					if lhs and k then
						add_sub_key(w, lhs, k.desc)
					end
				end
				wk.register(vim.tbl_deep_extend('error', opts, w))
			end

			vim.api.nvim_create_autocmd('filetype', {
				callback = function(args)
					local bufnr = args.buf
					local filetype = args.match

					local config = require('treesitter-sexp.config')
					if not config.options.enabled then
						return
					end

					local utils = require('treesitter-sexp.utils')
					local query = utils.get_query(filetype)
					if query == nil then
						return
					end

					local commands = require('treesitter-sexp.commands')
					local textobjects = require('treesitter-sexp.textobjects')
					local motions = require('treesitter-sexp.motions')
					local keymaps = config.options.keymaps

					if keymaps then
						add_which_key(
							keymaps.commands,
							commands,
							{ mode = { 'n' }, expr = true, buffer = bufnr }
						)
						add_which_key(
							keymaps.textobjects,
							textobjects,
							{ mode = { 'o', 'x' }, buffer = bufnr }
						)
						add_which_key(
							keymaps.motions,
							motions,
							{ mode = { 'n', 'o', 'x' }, buffer = bufnr }
						)
					end
				end,
				group = vim.api.nvim_create_augroup('nvimtreesitter-sexp-whichkey', {}),
			})
		end,
		opts = {
			-- enable/disable
			enabled = true,
			-- move cursor when applying commands
			set_cursor = true,
			-- set to false to disable all keymaps
			keymaps = {
				-- set to false to disable keymap type
				commands = {
					-- set to false to disable individual keymaps
					swap_prev_elem = '<e',
					swap_next_elem = '>e',
					swap_prev_form = '<f',
					swap_next_form = '>f',
					promote_elem = ',o',
					promote_form = ',o',
					splice = ',d',
					slurp_left = '<(',
					slurp_right = '>)',
					barf_left = '>(',
					barf_right = '<)',
					insert_head = '<i',
					insert_tail = '>i',
				},
				motions = {
					form_start = '[f',
					form_end = ']f',
					prev_elem = '[e', --"[e"
					next_elem = ']e', --"]e"
					prev_elem_end = false, --"[e"
					next_elem_end = false, --"]e"
					prev_top_level = '[F',
					next_top_level = ']F',
				},
				textobjects = {
					inner_elem = 'ie',
					outer_elem = 'ae',
					inner_form = 'if',
					outer_form = 'af',
					inner_top_level = 'if',
					outer_top_level = 'af',
				},
			},
		},
	},

	{ 'clojure-vim/clojure.vim', ft = 'clojure' },

	{ 'treybastian/nvim-jack-in', config = true, ft = 'clojure' },

	{
		'olical/conjure',
		ft = { 'clojure', 'python', 'markdown', 'lua' },
		branch = 'develop',
		config = function()
			require('conjure.main').main()
			require('conjure.mapping')['on-filetype']()
		end,
		dependencies = {
			'folke/which-key.nvim',
			{
				'paterjason/cmp-conjure',
				config = function(_, _)
					local function get_sources(arr)
						local config = {
							buffer = { name = 'buffer' },
							nvim_lsp = { name = 'nvim_lsp' },
							nvim_lua = { name = 'nvim_lua' },
							path = { name = 'path' },
							emoji = { name = 'emoji' },
							vsnip = { name = 'vsnip' },
							luasnip = { name = 'luasnip' },
							tmux = { name = 'tmux', option = { all_panes = true } },
							latex = { name = 'latex_symbols' },
							conjure = { name = 'conjure' },
						}
						local sources = {}
						for _, name in ipairs(arr) do
							sources[#sources + 1] = config[name]
						end
						return sources
					end
					local cmp = require('cmp')
					cmp.setup.filetype({ 'clojure' }, {
						sources = get_sources({
							'nvim_lsp',
							'buffer',
							'path',
							'luasnip',
							'tmux',
							'conjure',
						}),
					})
				end,
			},
		},
		init = function()
			vim.g['conjure#mapping#prefix'] = ','
			vim.g['conjure#mapping#log_split'] = 'lv'
			vim.g['conjure#mapping#log_toggle'] = 'ls'
			vim.g['conjure#mapping#log_vsplit'] = 'lg'
			vim.g['conjure#log#hud#width'] = 1
			vim.g['conjure#log#hud#anchor'] = 'SE'
			vim.g['conjure#highlight#enabled'] = true
			-- allow lisp k mapping and delegate this to ,k
			vim.g['conjure#mapping#doc_word'] = 'k'
			function Clerkshow()
				vim.cmd(':w')
				local current_ft = vim.bo.filetype
				vim.bo.filetype = 'clojure'
				vim.cmd(
					':conjureeval (nextjournal.clerk/show! "'
						.. vim.fn.expand('%:p')
						.. '")'
				)
				vim.bo.filetype = current_ft
			end
			vim.keymap.set(
				'n',
				',cs',
				':lua Clerkshow()<cr>',
				{ noremap = true, silent = true }
			)
			vim.api.nvim_create_autocmd('filetype', {
				group = vim.api.nvim_create_augroup('group_conjure-wk', {}),
				pattern = { 'clojure', 'python', 'markdown', 'lua' },
				callback = function(args)
					local wk = require('which-key')
					wk.register({
						[',c'] = { name = '+connect' },
						[',e'] = { name = '+evaluate' },
						[',g'] = { name = '+get' },
						[',l'] = { name = '+log' },
						[',r'] = { name = '+refresh' },
						[',s'] = { name = '+session' },
						[',t'] = { name = '+test' },
						[',v'] = { name = '+display' },
					}, { mode = 'n', buffer = args.buf })
					vim.keymap.set(
						'n',
						',n',
						':terminal bb conjure<cr>',
						{ noremap = true, silent = true, desc = 'nrepl' }
					)
				end,
			})
		end,
	},

	-- remove for now
	-- {
	-- 	'goerz/jupytext.vim',
	-- 	event = 'vimenter',
	-- },

	-- load and set keymapping only after using femaco
	-- at the moment the first call does not keep the window open
	{
		'acksld/nvim-femaco.lua',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		cmd = 'FeMaco',
		config = function()
			local clip_val = require('femaco.utils').clip_val
			vim.keymap.set(
				'n',
				'<leader>cb',
				'<cmd>FeMaco<cr>',
				{ desc = 'edit code block' }
			)
			local opts = {
				-- should prepare a new buffer and return the winid
				-- by default opens a floating window
				-- provide a different callback to change this behaviour
				-- @param opts: the return value from float_opts
				prepare_buffer = function(opts)
					local buf = vim.api.nvim_create_buf(false, false)
					return vim.api.nvim_open_win(buf, true, opts)
				end,
				-- should return options passed to nvim_open_win
				-- @param code_block: data about the code-block with the keys
				--   * range
				--   * lines
				--   * lang
				float_opts = function(code_block)
					local split = { split = 'below', win = 0 }
					local float = {
						relative = 'win',
						width = clip_val(5, 120, vim.api.nvim_win_get_width(0) - 10), -- todo how to offset sign column etc?
						height = clip_val(
							5,
							#code_block.lines,
							vim.api.nvim_win_get_height(0) - 6
						),
						anchor = 'nw',
						row = 0,
						col = 0,
						style = 'minimal',
						border = 'rounded',
						zindex = 1,
					}
					return split
				end,
				-- return filetype to use for a given lang
				-- lang can be nil
				ft_from_lang = function(lang)
					return lang
				end,
				-- what to do after opening the float
				post_open_float = function(_)
					vim.wo.signcolumn = 'no'
				end,
				-- create the path to a temporary file
				create_tmp_filepath = function(_)
					return os.tmpname()
				end,
				-- if a newline should always be used, useful for multiline injections
				-- which separators needs to be on separate lines such as markdown, neorg etc
				-- @param base_filetype: the filetype which femaco is called from, not the
				-- filetype of the injected language (this is the current buffer so you can
				-- get it from vim.bo.filetyp).
				ensure_newline = function(_)
					return false
				end,
			}
			require('femaco').setup(opts)
		end,
	},
}
