return {
	-- - repo: windwp/nvim-autopairs
	--   if: has('nvim-0.5')
	--   hook_post_source: lua require('local-plugins.autopairs')
	--
	-- - repo: guns/vim-sexp
	--   on_event: InsertCharPre
	--   on_ft: clojure
	--   hook_add: |
	--     let g:sexp_enable_insert_mode_mappings = 0
	-- - repo: tpope/vim-sexp-mappings-for-regular-people
	--   on_event: InsertCharPre
	--   on_ft: clojure
	--   depends: vim-sexp
	--
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
	-- - repo: hrsh7th/nvim-cmp
	--   if: has('nvim-0.5')
	--   on_event: VimEnter
	--   depends: [ nvim-autopairs, vim-vsnip ]
	--   hook_post_source: lua require('local-plugins.cmp')
	--
	-- - { repo: PaterJason/cmp-conjure, on_source: nvim-cmp, depends: conjure }
	--
	--
}
