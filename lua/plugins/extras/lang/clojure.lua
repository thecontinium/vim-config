return {

  { import = "lazyvim.plugins.extras.lang.clojure" },
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
            mode = "n",
            buffer = args.buf,
            { "<localleader>c", group = "+connect" },
            { "<localleader>e", group = "+evaluate" },
            { "<localleader>ec", group = "+comment" },
            { "<localleader>g", group = "+get" },
            { "<localleader>l", group = "+log" },
            { "<localleader>r", group = "+refresh" },
            { "<localleader>s", group = "+session" },
            { "<localleader>t", group = "+test" },
            { "<localleader>v", group = "+display" },
            { "<localleader>x", group = "+run" },
          })
        end,
      })
    end,
  },
  {
    "julienvincent/nvim-paredit",
    init = function()
      -- set af,if which-key correctly
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("group_paredit-wk", { clear = true }),
        pattern = "clojure", -- vim.g["conjure#filetypes"],
        callback = function(args)
          local wk = require("which-key")
          wk.add({
            mode = { "x", "o" },
            buffer = args.buf,
            { "af", desc = "Around form" },
            { "if", desc = "Inside form" },
          })
        end,
      })
    end,
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
          ["<localleader>w"] = {
            function()
              -- place cursor and set mode to `insert`
              paredit.cursor.place_cursor(
                -- wrap element under cursor with `( ` and `)`
                paredit.wrap.wrap_element_under_cursor("( ", ")"),
                -- cursor placement opts
                { placement = "inner_start", mode = "insert" }
              )
            end,
            "Wrap element insert head",
          },

          ["<localleader>W"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_element_under_cursor("(", " )"),
                { placement = "inner_end", mode = "insert" }
              )
            end,
            "Wrap element insert tail",
          },

          -- same as above but for enclosing form
          ["<localleader>i"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor("( ", ")"),
                { placement = "inner_start", mode = "insert" }
              )
            end,
            "Wrap form insert head",
          },

          ["<localleader>I"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor("(", " )"),
                { placement = "inner_end", mode = "insert" }
              )
            end,
            "Wrap form insert tail",
          },
        },
      })
    end,
  },
}
