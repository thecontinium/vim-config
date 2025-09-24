LazyVim.on_very_lazy(function()
  vim.filetype.add({
    filename = { Tmuxfile = "tmux" },
  })
end)

return {
  desc = "Tmux syntax, navigator (<C-h/j/k/l>), and completion.",
  recommended = function()
    return vim.env.TMUX ~= nil
  end,

  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "tmux" })
      end

      -- Setup filetype settings
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("mjn.ftplugin.tmux", {}),
        pattern = "tmux",
        callback = function()
          -- Open 'man tmux' in a vertical split with word under cursor.
          local function open_doc()
            local cword = vim.fn.expand("<cword>")
            require("man").open_page(0, { silent = true }, { "tmux" })
            vim.fn.search(cword)
          end

          vim.opt_local.iskeyword:append("-")

          vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
            .. "\n "
            .. "setlocal iskeyword<"
            .. "| sil! nunmap <buffer> gK"

          vim.keymap.set("n", "gK", open_doc, { buffer = 0 })
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Seamless navigation between tmux panes and vim splits
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cond = vim.env.TMUX and vim.uv.os_uname().sysname ~= "Windows_NT",
		-- stylua: ignore
		keys = {
			{ '<C-h>', '<cmd>TmuxNavigateLeft<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Left Window' },
			{ '<C-j>', '<cmd>TmuxNavigateDown<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Lower Window' },
			{ '<C-k>', '<cmd>TmuxNavigateUp<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Upper Window' },
			{ '<C-l>', '<cmd>TmuxNavigateRight<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Right Window' },
		},
    init = function()
      vim.g.tmux_navigator_no_mappings = true
    end,
  },

  -----------------------------------------------------------------------------
  -- Seamless navigation between tmux panes and vim splits
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cond = vim.env.TMUX and vim.uv.os_uname().sysname ~= "Windows_NT",
		-- stylua: ignore
		keys = {
			{ '<C-h>', '<cmd>TmuxNavigateLeft<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Left Window' },
			{ '<C-j>', '<cmd>TmuxNavigateDown<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Lower Window' },
			{ '<C-k>', '<cmd>TmuxNavigateUp<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Upper Window' },
			{ '<C-l>', '<cmd>TmuxNavigateRight<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Right Window' },
		},
    init = function()
      vim.g.tmux_navigator_no_mappings = true
    end,
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      "mgalliou/blink-cmp-tmux",
    },
    opts = {
      sources = {
        default = {
          --- your other sources
          "tmux",
        },
        providers = {
          tmux = {
            module = "blink-cmp-tmux",
            name = "tmux",
            -- default options
            opts = {
              all_panes = false,
              capture_history = false,
              -- only suggest completions from `tmux` if the `trigger_chars` are
              -- used
              triggered_only = false,
              trigger_chars = { "." },
            },
          },
        },
      },
    },
  },
}
