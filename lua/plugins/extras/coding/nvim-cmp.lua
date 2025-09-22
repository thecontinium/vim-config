return {
	{ import = 'rafi.plugins.extras.coding.nvim-cmp' },
	{
		'hrsh7th/nvim-cmp',
		optional = true,
		opts = function(_, opts)
			local formatting = {
				format = function(entry, item)
					-- Prepend with a fancy icon from config.
					local icons = LazyVim.config.icons
					if entry.source.name == 'git' then
						item.kind = icons.misc.git
					else
						local icon = icons.kinds[item.kind]
						if icon ~= nil then
							item.kind = icon .. item.kind
						end
					end
					local widths = {
						abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
						menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
					}

					for key, width in pairs(widths) do
						if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
							item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
						end
					end
					item.menu = ({
						buffer = '[Buffer]',
						nvim_lsp = '[LSP]',
						nvim_lua = '[Lua]',
						latex_symbols = '[LaTeX]',
						tmux = '[Tmux]',
						path = '[Path]',
						emoji = '[Emoji]',
						conjure = '[Conjure]',
						codeium = '[Codeium]',
						obsidian = '[Obsidian]',
						obsidian_new = '[Obsidian]',
						git = '[Git]',
						snippets = '',
					})[entry.source.name]
					if item.menu == nil then
						vim.notify(
							'Unknown source '
								.. entry.source.name
								.. ' Correct in extras.lua'
						)
					end
					return item
				end,
			}
			opts.formatting = vim.tbl_extend('force', opts.formatting, formatting)
		end,
	},
}
