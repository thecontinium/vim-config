return {
	'thecontinium/obsidian.nvim',
	version = '*', -- recommended, use latest release instead of latest commit
	lazy = true,
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
		'BufReadPre '
			.. vim.fn.expand('~')
			.. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/life',
		'BufNewFile '
			.. vim.fn.expand('~')
			.. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/life',
	},
	cmd = { 'ObsidianSearch', 'ObsidianQuickSwitch' },

	keys = {
		{ '<localleader>w', '<cmd>ObsidianQuickSwitch<CR>', desc = "Obsidian Quick Switch" },
	},
	dependencies = {
		-- Required.
		'nvim-lua/plenary.nvim',

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		pickers = {
			name = 'snacks.pick',
		},
		ui = { enable = false },
		note_id_func = function(title)
			local file_name = ''
			if title ~= nil then
				file_name = title
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					file_name = 'TEMP' .. string.char(math.random(65, 90))
				end
			end
			return file_name
		end,
		disable_frontmatter = true,
		workspaces = {
			{
				name = 'life',
				path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/life',
				overrides = {
					notes_subdir = 'notes',
				},
			},
		},
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ 'open', url }) -- Mac OS
			-- vim.fn.jobstart({"xdg-open", url})  -- linux
		end,

		-- see below for full list of options 👇
	},
}
