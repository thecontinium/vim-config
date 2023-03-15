return {
	{
		'jose-elias-alvarez/null-ls.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = { 'williamboman/mason.nvim' },
		opts = function()
			local builtins = require('null-ls').builtins
			local function has_exec(filename)
				return function()
					return vim.fn.executable(filename) == 1
				end
			end

			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
			return {
				-- Ensure key maps are setup
				debounce = 150,
				save_after_format = false,
				fallback_severity = vim.diagnostic.severity.INFO,

				should_attach = function(bufnr)
					return not vim.api.nvim_buf_get_name(bufnr):match('^[a-z]+://')
				end,

				sources = {
					-- Lua
					builtins.formatting.stylua,

					-- JSON
					builtins.formatting.fixjson.with({
						runtime_condition = has_exec('fixjson'),
						filetypes = { 'jsonc' },
					}),

					-- -- Ansible
					builtins.diagnostics.ansiblelint.with({
						runtime_condition = has_exec('ansible-lint'),
						extra_filetypes = { 'yaml.ansible' },
					}),

					-- Javascript
					builtins.diagnostics.eslint_d.with({
						runtime_condition = has_exec('eslint_d'),
					}),

					-- Go
					builtins.formatting.gofmt,
					builtins.formatting.gofumpt,
					builtins.formatting.golines,

					-- SQL
					builtins.formatting.sql_formatter,

					-- Shell
					builtins.formatting.shfmt.with({
						runtime_condition = has_exec('shfmt'),
					}),
					builtins.formatting.shellharden.with({
						runtime_condition = has_exec('shellharden'),
					}),

					-- Python
					builtins.diagnostics.mypy,

					-- Docker
					builtins.diagnostics.hadolint.with({
						runtime_condition = has_exec('hadolint'),
					}),

					-- Vim
					builtins.diagnostics.vint.with({
						runtime_condition = has_exec('vint'),
					}),

					-- Markdown
					builtins.diagnostics.markdownlint.with({
						runtime_condition = has_exec('markdownlint'),
					}),

					-- builtins.diagnostics.proselint.with({
					-- 	runtime_condition = has_exec('proselint'),
					-- 	diagnostics_postprocess = function(diagnostic)
					-- 		diagnostic.severity = vim.diagnostic.severity.HINT
					-- 	end,
					-- }),

					-- builtins.diagnostics.write_good.with({
					-- 	runtime_condition = has_exec('write-good'),
					-- 	diagnostics_postprocess = function(diagnostic)
					-- 		diagnostic.severity = vim.diagnostic.severity.HINT
					-- 	end,
					-- }),
				},
			}
		end,
	},
}
