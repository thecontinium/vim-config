return {
	{ import = 'lazyvim.plugins.extras.lang.clojure' },

	-- Extend auto completion
	{
		'hrsh7th/nvim-cmp',
		optional = true,
		dependencies = {
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

	{
		'Olical/conjure',
		dependencies = {
			'folke/which-key.nvim',
		},
		ft = { 'clojure' },
		event = function(_, event)
			-- remove any events that may trigger
			while #event ~= 0 do
				rawset(event, #event, nil)
			end
		end,
		init = function()
			vim.g['conjure#mapping#prefix'] = ','
			vim.g['conjure#filetypes'] = { -- remove python
				'clojure',
				'fennel',
				'janet',
				'hy',
				'julia',
				'racket',
				'scheme',
				'lua',
				'lisp',
				'rust',
				'sql',
			}
			vim.g['conjure#mapping#log_split'] = 'lv'
			vim.g['conjure#mapping#log_toggle'] = 'ls'
			vim.g['conjure#mapping#log_vsplit'] = 'lg'
			vim.g['conjure#log#hud#width'] = 1
			vim.g['conjure#log#hud#anchor'] = 'SE'
			vim.g['conjure#highlight#enabled'] = true
			-- allow lisp k mapping and delegate this to ,k
			vim.g['conjure#mapping#doc_word'] = 'k'
			vim.api.nvim_create_autocmd('filetype', {
				group = vim.api.nvim_create_augroup('group_conjure-wk', {}),
				pattern = vim.g['conjure#filetypes'],
				callback = function(args)
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
					local is_ft = function(ft)
						return args.match == ft
					end
					local wk = require('which-key')
					wk.add({
						{ ',', mode = 'n', buffer = args.buf, group = '+' .. args.match },
						{ ',c', mode = 'n', buffer = args.buf, group = '+connect' },
						{ ',e', mode = 'n', buffer = args.buf, group = '+evaluate' },
						{ ',ec', mode = 'n', buffer = args.buf, group = '+comment' },
						{ ',g', mode = 'n', buffer = args.buf, group = '+get' },
						{ ',l', mode = 'n', buffer = args.buf, group = '+log' },
						{ ',r', mode = 'n', buffer = args.buf, group = '+refresh' },
						{ ',s', mode = 'n', buffer = args.buf, group = '+session' },
						{ ',t', mode = 'n', buffer = args.buf, group = '+test' },
						{ ',v', mode = 'n', buffer = args.buf, group = '+display' },
						{
							',n',
							':terminal bb conjure<cr>',
							cond = is_ft('clojure'),
							mode = 'n',
							buffer = args.buf,
							desc = 'nrepl',
						},
						{
							',cs',
							':lua Clerkshow()<cr>',
							cond = is_ft('clojure'),
							mode = 'n',
							buffer = args.buf,
							desc = 'Clerk Show',
						},
					})
				end,
			})
		end,
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				clojure_lsp = {
					root_dir = function(startpath)
						vim.fs.dirname(
							vim.fs.find('.git', { path = startpath, upward = true })[1]
						)
					end or require('lspconfig.util').root_pattern(
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
	-----------------------------------------------------------------------------
	{
		'paterjason/nvim-treesitter-sexp',
		event = function(_, event)
			-- remove any events that may trigger
			while #event ~= 0 do
				rawset(event, #event, nil)
			end
		end,
		ft = 'clojure',
		dependencies = { 'nvim-mini/mini.surround', 'folke/which-key.nvim' },
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

			local function add_which_key(km, ks, opts)
				local wk = require('which-key')
				local w = {}
				for key, lhs in pairs(km) do
					local k = ks[key]
					if lhs and k then
						table.insert(
							w,
							vim.tbl_deep_extend('error', { lhs, desc = k.desc }, opts)
						)
					end
				end
				wk.add(w)
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
						add_which_key(keymaps.commands, commands, {
							mode = { 'n' },
							expr = true,
							buffer = bufnr,
							replace_keycodes = false,
						})
						add_which_key(keymaps.textobjects, textobjects, {
							mode = { 'o', 'x' },
							expr = true,
							buffer = bufnr,
							replace_keycodes = false,
						})
						add_which_key(keymaps.motions, motions, {
							mode = { 'n', 'o', 'x' },
							expr = true,
							buffer = bufnr,
							replace_keycodes = false,
						})
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
					inner_top_level = 'iF',
					outer_top_level = 'aF',
				},
			},
		},
	},

	{ 'clojure-vim/clojure.vim', ft = 'clojure' },
	-- { 'treybastian/nvim-jack-in', config = true, ft = 'clojure' },
}
