return {

  { import = "lazyvim.plugins.extras.lang.clojure" },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  {
    "Olical/conjure",
    dependencies = {
      "folke/which-key.nvim",
    },
    init = function()
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("group_conjure-wk", {}),
        pattern = vim.g["conjure#filetypes"],
        callback = function(args)
          local wk = require("which-key")
          wk.add({
            -- add conjure group names
            { "<localleader>c", mode = "n", buffer = args.buf, group = "+connect" },
            { "<localleader>e", mode = "n", buffer = args.buf, group = "+evaluate" },
            { "<localleader>ec", mode = "n", buffer = args.buf, group = "+comment" },
            { "<localleader>g", mode = "n", buffer = args.buf, group = "+get" },
            { "<localleader>l", mode = "n", buffer = args.buf, group = "+log" },
            { "<localleader>r", mode = "n", buffer = args.buf, group = "+refresh" },
            { "<localleader>s", mode = "n", buffer = args.buf, group = "+session" },
            { "<localleader>t", mode = "n", buffer = args.buf, group = "+test" },
            { "<localleader>v", mode = "n", buffer = args.buf, group = "+display" },
            { "<localleader>x", mode = "n", buffer = args.buf, group = "+run" },
          })
        end,
      })
    end,
  },
  {
    "julienvincent/nvim-paredit",
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup({
        -- Change some keys
        keys = {
          -- Don't conflict with flash
          ["T"] = false,
          ["gh"] = {
            require("nvim-paredit").api.move_to_top_level_form_head,
            "Jump to top level form's head",
            repeatable = false,
            mode = { "n", "x", "v" },
          },
        },
      })
    end,
    init = function()
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("group_treesitter-sexp", {}),
        pattern = "clojure",
        callback = function()
          vim.keymap.set(
            "n",
            "<localleader>w",
            "gsaie)(a <Left>",
            { buffer = true, remap = true, desc = "insert surround elem head" }
          )
          vim.keymap.set(
            "n",
            "<localleader>W",
            "gsaie))i ",
            { buffer = true, remap = true, desc = "insert surround elem tail" }
          )
          vim.keymap.set(
            "n",
            "<localleader>i",
            "gsaif)((a <Left>",
            { buffer = true, remap = true, desc = "insert surround form head" }
          )
          vim.keymap.set(
            "n",
            "<localleader>I",
            "gsaif)))i ",
            { buffer = true, remap = true, desc = "insert surround form tail" }
          )
        end,
      })
    end,
  },
}
