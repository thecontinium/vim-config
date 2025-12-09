return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { "iamcco/markdown-preview.nvim", enabled = false }, -- No Default Markdown Preview
  {
    "thecontinium/bullets.nvim",
    ft = "markdown",
    opts = {
      outline_levels = { "num", "std*", "std-", "std+" },
      keys = {
        newline_cr = { key = "<cr>", desc = "Insert New Bullet" },
        newline_o = { key = "o", desc = "Insert New Bullet Below" },
        renumber_visual = { key = "gR", desc = "Renumber Items" },
        renumber_normal = { key = "gR", desc = "Renumber Entire List" },
        toggle_checkbox = { key = "<localleader>xx", desc = "Toggle" },
        check_all = { key = "<localleader>xl", desc = "Entire List" },
        check_all_lists = { key = "<localleader>xb", desc = "Entire Buffer" },
        uncheck_all = { key = "<localleader>ul", desc = "Entire List" },
        uncheck_all_lists = { key = "<localleader>ub", desc = "Entire Buffer" },
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
      local wk = require("which-key")

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          wk.add({
            { "<localleader>x", group = "markdown check", buffer = true },
            { "<localleader>u", group = "markdown uncheck", buffer = true },
          })
        end,
      })
    end,
  },
}
