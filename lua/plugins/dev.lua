return {
	-- - repo: windwp/nvim-autopairs
	--   if: has('nvim-0.5')
	--   hook_post_source: lua require('local-plugins.autopairs')
	--
	{
		"guns/vim-sexp",
		ft = "clojure",
		config = function()
			vim.g.sexp_enable_insert_mode_mappings = 0
		end,
	},

	{
		"tpope/vim-sexp-mappings-for-regular-people",
		dependencies = { "guns/vim-sexp" },
		ft = "clojure",
		config = function()
			vim.g.sexp_enable_insert_mode_mappings = 0
			vim.g.sexp_mappings = {
				sexp_round_head_wrap_list = ",i",
				sexp_round_tail_wrap_list = ",I",
				sexp_square_head_wrap_list = "",
				sexp_square_tail_wrap_list = "",
				sexp_curly_head_wrap_list = "",
				sexp_curly_tail_wrap_list = "",
				sexp_round_head_wrap_element = ",w",
				sexp_round_tail_wrap_element = ",W",
				sexp_square_head_wrap_element = "",
				sexp_square_tail_wrap_element = "",
				sexp_curly_head_wrap_element = "",
				sexp_curly_tail_wrap_element = "",
				sexp_insert_at_list_head = ",h",
				sexp_insert_at_list_tail = ",l",
				sexp_splice_list = ",d",
				sexp_raise_list = ",o",
				sexp_raise_element = ",O",
			}
		end,
	},

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
	--
	-- - repo: clojure-vim/vim-jack-in
	--   on_cmd: [Clj, Lein]
	-- - repo: tpope/vim-dispatch
	--   on_source: vim-jack-in
	-- - repo: radenling/vim-dispatch-neovim
	--   on_source: vim-dispatch
	--
	{
		"Olical/conjure",
		ft = "clojure",
		config = function()
			vim.g["conjure#mapping#prefix"] = ","
			vim.g["conjure#mapping#log_split"] = "lv"
			vim.g["conjure#mapping#log_toggle"] = "ls"
			vim.g["conjure#mapping#log_vsplit"] = "lg"
			vim.g["conjure#log#hud#width"] = 1
			vim.g["conjure#log#hud#anchor"] = "SE"
			vim.g["conjure#highlight#enabled"] = true
			-- allow lisp K mapping and delegate this to ,K
			vim.g["conjure#mapping#doc_word"] = "K"
		end,
	},

	{
		"PaterJason/cmp-conjure",
		dependencies = { "hrsh7th/nvim-cmp" },
		ft = "clojure",
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
				sources = get_sources({ "nvim_lsp", "buffer", "path", "luasnip", "tmux", "conjure" }),
			})
		end,
	},
	--
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
