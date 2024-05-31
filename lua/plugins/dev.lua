-- vim.cmd.runtime("plugin/zipPlugin.vim")

return {
	-- - repo: windwp/nvim-autopairs
	--   if: has('nvim-0.5')
	--   hook_post_source: lua require('local-plugins.autopairs')
	--
	-- {
	-- 	"guns/vim-sexp",
	-- 	ft = "clojure",
	-- 	config = function(_, _)
	-- 		-- vim.g.sexp_enable_insert_mode_mappings = 0
	-- 		vim.g.sexp_mappings = {
	-- 			sexp_round_head_wrap_list = ",i",
	-- 			sexp_round_tail_wrap_list = ",I",
	-- 			sexp_square_head_wrap_list = "",
	-- 			sexp_square_tail_wrap_list = "",
	-- 			sexp_curly_head_wrap_list = "",
	-- 			sexp_curly_tail_wrap_list = "",
	-- 			sexp_round_head_wrap_element = ",w",
	-- 			sexp_round_tail_wrap_element = ",W",
	-- 			sexp_square_head_wrap_element = "",
	-- 			sexp_square_tail_wrap_element = "",
	-- 			sexp_curly_head_wrap_element = "",
	-- 			sexp_curly_tail_wrap_element = "",
	-- 			sexp_insert_at_list_head = ",h",
	-- 			sexp_insert_at_list_tail = ",l",
	-- 			sexp_splice_list = ",d",
	-- 			sexp_raise_list = ",o",
	-- 			sexp_raise_element = ",O",
	-- 		}
	-- 	end,
	-- },

	-- # Movement
	-- ()      move cursor to matching paren (same as % but easier) _[SEXP]_
	-- [[ ]]   move cursor to top-level element _[SEXP]_
	-- W B E   move cursor element/form-wise
	--
	-- # Indent
	-- ==      indent form  _[SEXP]_
	-- =-      indent top level _[SEXP]_
	-- =<movement>  indent whatever
	--
	-- # Move elements/forms around
	-- >e <e     move element right/left
	-- >f <f     move form right/left
	--
	-- # Slurpage and barfage
	-- <( >)       slurp (push paren out wider)
	-- >( <)       barf  (pull paren in narrower)
	--
	-- # Insertion, some with new parens
	-- cse)     add surround form — easier than ysie)
	-- <I >I    insert front/end — don’t use, too diff from ,i/,I
	-- ,h ,l    insert front/end _[SEXP]_
	-- ,i ,I    insert front/end, add surround form _[SEXP]_
	-- ,w ,W    insert front/end, add surround element _[SEXP]_
	--
	-- # Deletion
	-- dsf      delete form (splice ,@)
	-- daf dif  delete around/in form
	-- ,o       delete outer form _[SEXP]_
	{
		"PaterJason/nvim-treesitter-sexp",
		ft = "clojure",
		dependencies = 'echasnovski/mini.surround',
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('group_treesitter-sexp', {}),
				pattern = 'clojure',
				callback = function()
					vim.keymap.set('n', ',w', 'saie)<I',
						{ buffer = true, remap = true, desc = 'Insert surround elem head' })
					vim.keymap.set('n', ',W', 'saie)>I ',
						{ buffer = true, remap = true, desc = 'Insert surround elem tail' })
					vim.keymap.set('n', ',i', 'saif)((<I',
						{ buffer = true, remap = true, desc = 'Insert surround form head' })
					vim.keymap.set('n', ',I', 'saif)))>I ',
						{ buffer = true, remap = true, desc = 'Insert surround form head' })
				end,
			})
		end,
		opts = {
			-- Enable/disable
			enabled = true,
			-- Move cursor when applying commands
			set_cursor = true,
			-- Set to false to disable all keymaps
			keymaps = {
				-- Set to false to disable keymap type
				commands = {
					-- Set to false to disable individual keymaps
					swap_prev_elem = "<e",
					swap_next_elem = ">e",
					swap_prev_form = "<f",
					swap_next_form = ">f",
					promote_elem = ",O",
					promote_form = ",o",
					splice = ",d",
					slurp_left = "<(",
					slurp_right = ">)",
					barf_left = ">(",
					barf_right = "<)",
					insert_head = "<I",
					insert_tail = ">I",
				},
				motions = {
					form_start = "(",
					form_end = ")",
					prev_elem = "[E", --"[e"
					next_elem = "]E", --"]e"
					prev_elem_end = false, --"[E"
					next_elem_end = false, --"]E"
					prev_top_level = "[[",
					next_top_level = "]]",
				},
				textobjects = {
					inner_elem = "ie",
					outer_elem = "ae",
					inner_form = "if",
					outer_form = "af",
					inner_top_level = "iF",
					outer_top_level = "aF",
				},
			},
		},
	},

	-- {
	-- 	"echasnovski/mini.pairs",
	-- 	event = "VeryLazy",
	-- 	config = function(_, opts)
	-- 		require("mini.pairs").setup(opts)
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			group = vim.api.nvim_create_augroup("clojure_mini_pair", {}),
	-- 			pattern = { "clojure" },
	-- 			callback = function()
	-- 				vim.b.minipairs_disable = true
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	-- - repo: thecontinium/marked-streaming-nvim
	--   on_ft: markdown
	--   hook_post_update : |-
	--     call system(join([fnamemodify(g:python3_host_prog,":p:h"),"pip install -U pyobjc"],"/"))
	--   hook_source: |
	--     let g:marked_streaming_events = 'InsertLeave,CursorHold'
	--     let g:marked_streaming_open_mapping = '<Leader>O'
	-- - repo: tpope/vim-repeat
	--   on-source: conjure
	--
	{ "clojure-vim/clojure.vim", ft = "clojure" },

	{
		"clojure-vim/vim-jack-in",
		cmd = { 'Clj', 'Lein' },
		dependencies = { "radenling/vim-dispatch-neovim", "tpope/vim-dispatch" },
	},

	{
		"Olical/conjure",
		ft = { "clojure", "python", "markdown" },
		branch = "develop",
		config = function()
			require("conjure.main").main()
			require("conjure.mapping")["on-filetype"]()
		end,
		dependencies = {
			{
				"PaterJason/cmp-conjure",
				config = function(_, _)
					local function get_sources(arr)
						local config = {
							buffer = { name = "buffer" },
							nvim_lsp = { name = "nvim_lsp" },
							nvim_lua = { name = "nvim_lua" },
							path = { name = "path" },
							emoji = { name = "emoji" },
							vsnip = { name = "vsnip" },
							luasnip = { name = "luasnip" },
							tmux = { name = "tmux", option = { all_panes = true } },
							latex = { name = "latex_symbols" },
							conjure = { name = "conjure" },
						}
						local sources = {}
						for _, name in ipairs(arr) do
							sources[#sources + 1] = config[name]
						end
						return sources
					end
					local cmp = require("cmp")
					cmp.setup.filetype({ "clojure" }, {
						sources = get_sources({ "nvim_lsp", "buffer", "path", "luasnip",
							"tmux", "conjure" }),
					})
				end,
			},
		},
		init = function()
			vim.g["conjure#mapping#prefix"] = ","
			vim.g["conjure#mapping#log_split"] = "lv"
			vim.g["conjure#mapping#log_toggle"] = "ls"
			vim.g["conjure#mapping#log_vsplit"] = "lg"
			vim.g["conjure#log#hud#width"] = 1
			vim.g["conjure#log#hud#anchor"] = "SE"
			vim.g["conjure#highlight#enabled"] = true
			-- allow lisp K mapping and delegate this to ,K
			vim.g["conjure#mapping#doc_word"] = "K"
			function ClerkShow()
				vim.cmd(":w")
				local current_ft = vim.bo.filetype
				vim.bo.filetype = "clojure"
				vim.cmd(':ConjureEval (nextjournal.clerk/show! "' ..
					vim.fn.expand("%:p") .. '")')
				vim.bo.filetype = current_ft
			end

			vim.api.nvim_set_keymap('n', ',cs', ':lua ClerkShow()<CR>',
				{ noremap = true, silent = true })
		end,
	},

	-- {
	-- 	"gpanders/nvim-parinfer",
	-- 	ft = "clojure",
	-- },


	{
		"goerz/jupytext.vim",
		event = "VimEnter",
	},

	{
		"AckslD/nvim-FeMaco.lua",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "FeMaco",
		config = function(_, _)
			require("femaco").setup({
				-- should prepare a new buffer and return the winid
				-- by default opens a floating window
				-- provide a different callback to change this behaviour
				-- @param opts: the return value from float_opts
				prepare_buffer = function(opts)
					local bufnr = vim.api.nvim_create_buf(false, false)
					print("matthew")
					vim.cmd("split")
					vim.cmd(string.format("buffer %d", bufnr))
					return vim.api.nvim_get_current_win()
					-- local buf = vim.api.nvim_create_buf(false, false)
					-- return vim.api.nvim_open_win(buf, true, opts)
				end,
				-- should return options passed to nvim_open_win
				-- @param code_block: data about the code-block with the keys
				--   * range
				--   * lines
				--   * lang
				float_opts = function(code_block)
					return {}
				end,
				-- return filetype to use for a given lang
				-- lang can be nil
				ft_from_lang = function(lang)
					return lang
				end,
				-- what to do after opening the float
				post_open_float = function(winnr)
					vim.wo.signcolumn = "no"
				end,
				-- create the path to a temporary file
				create_tmp_filepath = function(filetype)
					return os.tmpname()
				end,
				-- if a newline should always be used, useful for multiline injections
				-- which separators needs to be on separate lines such as markdown, neorg etc
				-- @param base_filetype: The filetype which FeMaco is called from, not the
				-- filetype of the injected language (this is the current buffer so you can
				-- get it from vim.bo.filetyp).
				ensure_newline = function(base_filetype)
					return false
				end,
			})
		end,
	},
	-- - repo: tpope/vim-projectionist
	--   on_ft: clojure
	--   hook_add: |-
	--     autocmd User ProjectionistDetect
	--       \ call projectionist#append(getcwd(),
	--       \ {
	--       \   'src/*.clj': {
	--       \     'alternate': 'test/{}_test.clj',
	--       \     'type': 'source'
	--       \   },
	--       \   'test/*_test.clj': {
	--       \     'alternate': 'src/{}.clj',
	--       \     'type': 'test'
	--       \   },
	--       \ })
	--
}
