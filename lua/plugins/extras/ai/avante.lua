local prefix = '<Leader>i'
return {
	'yetone/avante.nvim',
	event = 'VeryLazy',
	lazy = false,
	version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	opts = {
		provider = 'gemini',
		providers = {
			gemini = {
				model = 'gemini-2.0-flash', -- your desired model (or use gpt-4o, etc.)
			},
		},
		-- add any opts here
		mappings = {
			ask = prefix .. 'a',
			new_ask = prefix .. 'n',
			edit = prefix .. 'e',
			refresh = prefix .. 'r',
			focus = prefix .. 'f',
			stop = prefix .. 'S',
			toggle = {
				default = prefix .. 't',
				debug = prefix .. 'd',
				hint = prefix .. 'h',
				suggestion = prefix .. 's',
				repomap = prefix .. 'R',
			},
			diff = {
				next = ']c',
				prev = '[c',
			},
			files = {
				add_current = prefix .. 'c',
				add_all_buffers = prefix .. 'B',
			},
			select_model = prefix .. '?', -- Select model command
			select_history = prefix .. 'h', -- Select history command
		},
		behaviour = {
			auto_suggestions = false, -- Experimental stage
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
		},
		-- system_prompt as function ensures LLM always has latest MCP server state
		-- This is evaluated for every message, even in existing chats
		system_prompt = function()
			local hub = require('mcphub').get_hub_instance()
			return hub and hub:get_active_servers_prompt() or ''
		end,
		-- Using function prevents requiring mcphub before it's loaded
		custom_tools = function()
			return {
				require('mcphub.extensions.avante').mcp_tool(),
			}
		end,
		disabled_tools = {
			'list_files', -- Built-in file operations
			'search_files',
			'read_file',
			'create_file',
			'rename_file',
			'delete_file',
			'create_dir',
			'rename_dir',
			'delete_dir',
			'bash', -- Built-in terminal access
		},
	},
	build = 'make', -- if you want to build from source then do make BUILD_FROM_SOURCE=true
	dependencies = {
		'stevearc/dressing.nvim',
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		--- The below dependencies are optional,
		'echasnovski/mini.pick', -- for file_selector provider mini.pick
		{
		  'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
			optional = true,
		},
		{
			'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
			optional = true,
		},
		'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
		{
			-- support for image pasting
			'HakonHarnes/img-clip.nvim',
			event = 'VeryLazy',
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
		{
			'ravitemer/mcphub.nvim',
			dependencies = {
				'nvim-lua/plenary.nvim',
			},
			build = 'bundled_build.lua', -- Bundles `mcp-hub` binary along with the neovim plugin
			config = function()
				require('mcphub').setup({
					use_bundled_binary = true, -- Use local `mcp-hub` binary
				})
			end,
		},
	},
}
