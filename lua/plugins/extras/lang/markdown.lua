return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { "iamcco/markdown-preview.nvim", enabled = false }, -- No Default Markdown Preview

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("$XDG_CONFIG_HOME/markdownlint/.markdownlint-cli2.yaml"), "--" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.expand("$XDG_CONFIG_HOME/markdownlint/.markdownlint-cli2.yaml"),
            "--fix",
            "$FILENAME",
          },
        },
      },
    },
  },
  {
    "thecontinium/bullets.nvim",
    ft = "markdown",
    dependencies = { { "libmodal" } },
    opts = {
      outline_levels = { "num", "std*", "std-", "std+" },
      keys = {
        newline_cr = { key = "<cr>", desc = "Insert New Bullet" },
        newline_o = { key = "o", desc = "Insert New Bullet Below" },
        renumber_visual = { key = "gR", desc = "Renumber Items" },
        renumber_normal = { key = "gR", desc = "Renumber Entire List" },
        toggle_checkbox = { key = nil, desc = "Toggle Markdown Checkbox" },
        check_all = { key = nil, desc = "Check Entire List" },
        check_all_lists = { key = nil, desc = "Check Entire Buffer" },
        uncheck_all = { key = nil, desc = "Uncheck Entire List" },
        uncheck_all_lists = { key = nil, desc = "Uncheck Entire Buffer" },
        demote_insert = { key = "<C-t>", desc = "Demote Bullet " },
        demote_normal = { key = ">>", desc = "Demote Bullet " },
        demote_visual = { key = ">", desc = "Demote Bullets" },
        promote_insert = { key = "<C-d>", desc = "Promote Bullet" },
        promote_normal = { key = "<<", desc = "Promote Bullet" },
        promote_visual = { key = "<", desc = "Promote Bullets" },
      },
    },
    config = function(_, opts)
      require("Bullets").setup(opts)
      local libmodal = require("libmodal")
      local checkKeyMap = {
        n = { -- normal mode mappings
          t = { rhs = "<Plug>(bullets-toggle-checkbox)", noremap = true, desc = "[L] Toggle Markdown Checkbox" },
          c = { rhs = "<Plug>(bullets-check-all)", noremap = true, desc = "[L] Check Entire List" },
          C = { rhs = "<Plug>(bullets-uncheck-all)", noremap = true, desc = "[L] Uncheck Entire List" },
          b = { rhs = "<Plug>(bullets-check-all-lists)", noremap = true, desc = "[L] Check Entire Buffer" },
          B = { rhs = "<Plug>(bullets-uncheck-all-lists)", noremap = true, desc = "[L] Uncheck Entire Buffer" },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<Leader>ch", function()
            libmodal.layer.enter(checkKeyMap, "<Esc>")
          end, { desc = "Check Layer", buffer = true })
        end,
      })
    end,
  },
}
